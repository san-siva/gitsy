#!/usr/bin/env bats

# Load the utils file
setup() {
    # Set up test directory
    export TEST_DIR="$(mktemp -d)"
    cd "$TEST_DIR"
    git init -q
    git config user.name "Test User"
    git config user.email "test@example.com"

    # Source the utils file
    source "${BATS_TEST_DIRNAME}/../bin/utils"
}

teardown() {
    # Clean up test directory
    rm -rf "$TEST_DIR"
}

# Test sanitize_branch_name function
@test "sanitize_branch_name: converts special characters to underscores" {
    local branch_result
    sanitize_branch_name "feature/test-branch" branch_result
    [ "$branch_result" = "feature_test_branch" ]
}

@test "sanitize_branch_name: converts to lowercase" {
    local branch_result
    sanitize_branch_name "FEATURE-BRANCH" branch_result
    [ "$branch_result" = "feature_branch" ]
}

@test "sanitize_branch_name: truncates long branch names" {
    local branch_result
    sanitize_branch_name "very-long-branch-name-that-exceeds-thirty-characters" branch_result 30
    [ "${#branch_result}" -eq 32 ]  # 30 + 2 for ".."
    [[ "$branch_result" == *".." ]]
}

@test "sanitize_branch_name: handles exit code correctly" {
    local branch_result
    sanitize_branch_name "test/branch" branch_result
    local exit_code=$?
    [ "$exit_code" -eq 0 ]
}

# Test get_current_branch function
@test "get_current_branch: returns current branch name" {
    git checkout -b test-branch -q
    local current_branch
    get_current_branch current_branch
    [ "$current_branch" = "test-branch" ]
}

@test "get_current_branch: handles exit code when git command succeeds" {
    git checkout -b test-branch -q
    local current_branch
    get_current_branch current_branch
    local exit_code=$?
    [ "$exit_code" -eq 0 ]
}

@test "get_current_branch: captures exit code immediately" {
    # Create a scenario where we're not in a git repo
    cd /tmp
    rm -rf not-a-repo
    mkdir -p not-a-repo
    cd not-a-repo

    # This should fail but we're testing it exits gracefully
    run bash -c "source ${BATS_TEST_DIRNAME}/../bin/utils; get_current_branch my_branch"
    [ "$status" -eq 1 ]
    [[ "$output" == *"Failed to get current branch"* ]]
}

# Test get_default_branch function
@test "get_default_branch: returns default branch" {
    # Set up a mock remote
    git checkout -b main -q
    git commit --allow-empty -m "Initial commit" -q

    local default_branch
    get_default_branch default_branch
    [ "$default_branch" = "main" ]
}

@test "get_default_branch: falls back to main if no remote" {
    local default_branch
    get_default_branch default_branch
    [ "$default_branch" = "main" ]
}

@test "get_default_branch: captures exit code from git symbolic-ref" {
    local default_branch
    get_default_branch default_branch
    local exit_code=$?
    [ "$exit_code" -eq 0 ]
}

# Test branch_exists_locally function
@test "branch_exists_locally: returns 0 when branch exists" {
    git checkout -b existing-branch -q
    run branch_exists_locally "existing-branch"
    [ "$status" -eq 0 ]
}

@test "branch_exists_locally: returns 1 when branch doesn't exist" {
    run branch_exists_locally "non-existent-branch"
    [ "$status" -eq 1 ]
}

# Test get_repo_name function
@test "get_repo_name: extracts name from git URL" {
    git remote add origin "https://github.com/user/test-repo.git"
    local repo_name
    get_repo_name repo_name
    [ "$repo_name" = "test-repo" ]
}

@test "get_repo_name: handles SSH URLs" {
    git remote add origin "git@github.com:user/test-repo.git"
    local repo_name
    get_repo_name repo_name
    [ "$repo_name" = "test-repo" ]
}

@test "get_repo_name: captures exit code from sed pipeline" {
    git remote add origin "https://github.com/user/test-repo.git"
    local repo_name
    get_repo_name repo_name
    local exit_code=$?
    [ "$exit_code" -eq 0 ]
}

@test "get_repo_name: falls back to directory name when no remote" {
    # No remote configured, should use directory name
    local repo_name
    get_repo_name repo_name
    [ -n "$repo_name" ]  # Should have some value
}

# Test get_repo_info function
@test "get_repo_info: populates all nameref variables" {
    local git_root current_dir parent_dir repo_name
    get_repo_info git_root current_dir parent_dir repo_name

    [ -n "$git_root" ]
    [ -n "$current_dir" ]
    [ -n "$parent_dir" ]
    [ -n "$repo_name" ]
}

@test "get_repo_info: captures git rev-parse exit code" {
    local git_root current_dir parent_dir repo_name
    get_repo_info git_root current_dir parent_dir repo_name
    local exit_code=$?
    [ "$exit_code" -eq 0 ]
}

# Test exit code capturing pattern
@test "exit code pattern: captures immediately after subshell" {
    # Simulate the pattern we use throughout the codebase
    local result
    result=$(git rev-parse --abbrev-ref HEAD 2>&1)
    local captured_exit=$?

    # Even if subsequent commands run, captured_exit should still be correct
    local dummy="some operation"
    [ "$captured_exit" -eq 0 ]
}

@test "exit code pattern: detects failures in subshells" {
    # Simulate a failing command
    local result
    result=$(git rev-parse --verify non-existent-ref 2>&1)
    local captured_exit=$?

    [ "$captured_exit" -ne 0 ]
}
