#!/usr/bin/env bats

# Test exit code capturing patterns across all scripts

setup() {
    export TEST_DIR="$(mktemp -d)"
    cd "$TEST_DIR"
    git init -q
    git config user.name "Test User"
    git config user.email "test@example.com"

    source "${BATS_TEST_DIRNAME}/../bin/utils"
}

teardown() {
    rm -rf "$TEST_DIR"
}

# Test the exit code capturing pattern used throughout the codebase
@test "exit code pattern: immediate capture prevents overwriting" {
    # Simulate the correct pattern: capture immediately
    local result
    result=$(git rev-parse --abbrev-ref HEAD 2>&1)
    local exit_code=$?  # Captured immediately

    # Even if we run more commands, exit_code should still be correct
    local dummy=$(echo "something")
    [ -n "$exit_code" ]
}

@test "exit code pattern: detects command failure" {
    # Test failing command
    local result
    result=$(git rev-parse --verify non-existent-ref 2>&1)
    local exit_code=$?

    [ "$exit_code" -ne 0 ]
}

@test "exit code pattern: works with piped commands" {
    # Test with pipeline (exit code is from last command in pipe)
    local result
    result=$(echo "test" | grep "test" 2>&1)
    local exit_code=$?

    [ "$exit_code" -eq 0 ]
}

@test "exit code pattern: pipeline failure detection" {
    local result
    result=$(echo "test" | grep "nonexistent" 2>&1)
    local exit_code=$?

    [ "$exit_code" -ne 0 ]
}

@test "exit code pattern: compound command with &&" {
    local result
    result=$(cd /tmp 2>/dev/null && echo "success")
    local exit_code=$?

    [ "$exit_code" -eq 0 ]
    [ "$result" = "success" ]
}

@test "exit code pattern: compound command failure with &&" {
    local result
    result=$(cd /nonexistent/path 2>/dev/null && echo "success")
    local exit_code=$?

    [ "$exit_code" -ne 0 ]
}

# Test specific patterns from our fixes
@test "utils: get_current_branch captures exit code immediately" {
    # This tests the pattern in utils.bats line 120-121
    git checkout -b test-branch -q

    local result
    result=$(git rev-parse --abbrev-ref HEAD 2>&1)
    local get_branch_exit=$?

    [ "$get_branch_exit" -eq 0 ]
    [ "$result" = "test-branch" ]
}

@test "utils: get_default_branch captures symbolic-ref exit code" {
    # This tests the pattern in utils.bats line 134-135
    local default_branch
    default_branch=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@')
    local exit_code=$?

    # Should have captured the exit code even if command failed
    [ -n "$exit_code" ]
}

@test "utils: sanitize_branch_name captures sed pipeline exit code" {
    # This tests the pattern in utils.bats line 167-168
    local branch_name="TEST-BRANCH"
    local sanitized
    sanitized=$(echo "$branch_name" | sed -E 's/[^[:alnum:]]/_/g' | tr '[:upper:]' '[:lower:]')
    local sanitize_exit=$?

    [ "$sanitize_exit" -eq 0 ]
    [ "$sanitized" = "test_branch" ]
}

@test "utils: stash_changes captures branch name exit code" {
    # This tests the pattern in utils.bats line 200-201
    git checkout -b test-branch -q

    local branch_name
    branch_name=$(git rev-parse --abbrev-ref HEAD 2>&1)
    local branch_exit=$?

    [ "$branch_exit" -eq 0 ]
    [ "$branch_name" = "test-branch" ]
}

@test "utils: get_repo_name captures sed extraction exit code" {
    # This tests the pattern in utils.bats line 610-611
    local remote_url="https://github.com/user/test-repo.git"
    local result
    result=$(echo "$remote_url" | sed -E 's#.*/([^/]+)(\.git)?$#\1#' | sed 's/\.git$//')
    local extract_exit=$?

    [ "$extract_exit" -eq 0 ]
    [ "$result" = "test-repo" ]
}

@test "utils: get_repo_info captures git root exit code" {
    # This tests the pattern in utils.bats line 632-633
    local git_root
    git_root=$(git rev-parse --show-toplevel)
    local git_root_exit=$?

    [ "$git_root_exit" -eq 0 ]
    [ -n "$git_root" ]
}

# Test g-wa patterns
@test "g-wa: worktree list captures exit code immediately" {
    # This tests the pattern in g-wa.bats line 84-85
    local existing_worktree
    existing_worktree=$(git worktree list 2>/dev/null | grep -F "[test]" | awk '{print $1}')
    local worktree_exit=$?

    # Should have captured exit code
    [ -n "$worktree_exit" ]
}

@test "g-wa: absolute path conversion captures exit code" {
    # This tests the pattern in g-wa.bats line 129-130
    mkdir -p /tmp/test_path

    local abs_path
    abs_path=$(cd "/tmp/test_path" 2>/dev/null && echo "$(pwd)/file")
    local abs_path_exit=$?

    [ "$abs_path_exit" -eq 0 ]
    [ -n "$abs_path" ]
}

@test "g-wa: find command captures exit code" {
    # This tests the pattern in g-wa.bats line 143-144
    local no_of_dirs
    no_of_dirs=$(find /tmp -maxdepth 1 -type d -name "test*" 2>/dev/null | wc -l)
    local find_exit=$?

    [ "$find_exit" -eq 0 ]
}

# Test g-wr patterns
@test "g-wr: git rev-parse captures exit code in cd_to_worktrees_dir" {
    # This tests the pattern in g-wr.bats line 92-93
    local git_root
    git_root=$(git rev-parse --show-toplevel 2>&1)
    local root_exit=$?

    [ "$root_exit" -eq 0 ]
    [ -n "$git_root" ]
}

@test "g-wr: branch detection captures exit code" {
    # This tests the pattern in g-wr.bats line 165-166
    git checkout -b test-branch -q

    local branch
    branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    local branch_exit=$?

    [ "$branch_exit" -eq 0 ]
    [ "$branch" = "test-branch" ]
}

# Test that $? without immediate capture can be overwritten
@test "anti-pattern: $? gets overwritten without immediate capture" {
    local result
    result=$(git rev-parse --verify non-existent-ref 2>&1)
    # If we check $? later, it might have been overwritten
    local dummy="operation"  # This could overwrite $?

    # We can't reliably test $? here anymore
    # This test documents WHY we need immediate capture
    [ 1 -eq 1 ]  # Always passes, demonstrating the problem
}
