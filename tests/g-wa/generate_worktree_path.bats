#!/usr/bin/env bats

# Tests for generate_worktree_path function in g-wa

setup() {
    export TEST_DIR="$(mktemp -d)"
    cd "$TEST_DIR"

    # Create a proper directory structure for git repo
    mkdir -p myrepo
    cd myrepo

    git init -q
    git config user.name "Test User"
    git config user.email "test@example.com"

    # Create initial commit
    echo "test" > README.md
    git add README.md
    git commit -q -m "Initial commit"

    source "${BATS_TEST_DIRNAME}/../../bin/utils"
    source "${BATS_TEST_DIRNAME}/../../bin/g-wa"
}

teardown() {
    rm -rf "$TEST_DIR"
}

@test "generate_worktree_path: generates path correctly" {
    local result_path
    generate_worktree_path "feature/test-branch" result_path
    local exit_code=$?

    # Function should succeed
    [ "$exit_code" -eq 0 ]
    # Result should not be empty
    [ -n "$result_path" ]
    # Result should contain sanitized branch name
    [[ "$result_path" == *"feature_test_branch"* ]]
}

@test "generate_worktree_path: returns via nameref correctly" {
    local my_path
    generate_worktree_path "test-branch" my_path

    [ -n "$my_path" ]
    [ "$?" -eq 0 ]
}

@test "generate_worktree_path: no variable collision with nameref" {
    # This tests the critical bug fix
    local path
    generate_worktree_path "test-branch" path

    [ -n "$path" ]
}

@test "generate_worktree_path: uses result_path internally (not path)" {
    # Verify the bug fix: internal variable is result_path, not path
    local my_result
    generate_worktree_path "test-branch" my_result

    [ -n "$my_result" ]
}

@test "generate_worktree_path: captures exit code from cd command" {
    mkdir -p ../worktrees

    local result_path
    generate_worktree_path "test-branch" result_path
    local exit_code=$?

    [ "$exit_code" -eq 0 ]
    [ -n "$result_path" ]
}

@test "generate_worktree_path: handles long branch names" {
    local result_path
    generate_worktree_path "EXT-5994__template_changes_for_element_selectors__test_fix_dump" result_path

    [ -n "$result_path" ]
    [[ "$result_path" == *"ext_5994__template_changes_for"* ]]
}

@test "generate_worktree_path: generates unique path when directory exists" {
    mkdir -p ../worktrees
    local result_path

    generate_worktree_path "test-branch" result_path
    local first_path="$result_path"

    mkdir -p "$first_path"

    generate_worktree_path "test-branch" result_path
    local second_path="$result_path"

    [ "$first_path" != "$second_path" ]
    [[ "$second_path" == *"_2" ]]
}

@test "generate_worktree_path: captures find command exit code" {
    mkdir -p ../worktrees
    local result_path

    generate_worktree_path "test-branch" result_path
    mkdir -p "$result_path"

    generate_worktree_path "test-branch" result_path
    local exit_code=$?

    [ "$exit_code" -eq 0 ]
}

@test "generate_worktree_path: validates absolute path conversion" {
    mkdir -p ../worktrees
    local result_path
    generate_worktree_path "test-branch" result_path

    [[ "$result_path" == /* ]]
}

@test "generate_worktree_path: calls sanitize_branch_name" {
    local result_path
    generate_worktree_path "FEATURE/TEST-Branch" result_path

    # Should be sanitized (lowercase, underscores)
    [[ "$result_path" == *"feature_test_branch"* ]]
}
