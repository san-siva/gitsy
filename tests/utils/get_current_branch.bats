#!/usr/bin/env bats

# Tests for get_current_branch function

setup() {
    export TEST_DIR="$(mktemp -d)"
    cd "$TEST_DIR"
    git init -q
    git config user.name "Test User"
    git config user.email "test@example.com"

    # Create initial commit so branches have refs
    echo "test" > README.md
    git add README.md
    git commit -q -m "Initial commit"

    source "${BATS_TEST_DIRNAME}/../../bin/utils"
}

teardown() {
    rm -rf "$TEST_DIR"
}

@test "get_current_branch: returns current branch name" {
    git checkout -b test-branch -q

    local current_branch
    get_current_branch current_branch

    [ "$current_branch" = "test-branch" ]
}

@test "get_current_branch: returns main branch" {
    git checkout -b main -q

    local current_branch
    get_current_branch current_branch

    [ "$current_branch" = "main" ]
}

@test "get_current_branch: handles exit code correctly on success" {
    git checkout -b test-branch -q

    local current_branch
    get_current_branch current_branch
    local exit_code=$?

    [ "$exit_code" -eq 0 ]
    [ -n "$current_branch" ]
}

@test "get_current_branch: captures exit code immediately after git command" {
    git checkout -b test-branch -q

    # Simulate the pattern in the code
    local result
    result=$(git rev-parse --abbrev-ref HEAD 2>&1)
    local get_branch_exit=$?

    [ "$get_branch_exit" -eq 0 ]
    [ "$result" = "test-branch" ]
}

@test "get_current_branch: works with feature branch names" {
    git checkout -b feature/test-feature -q

    local current_branch
    get_current_branch current_branch

    [ "$current_branch" = "feature/test-feature" ]
}

@test "get_current_branch: works with release branch names" {
    git checkout -b release/1.0.0 -q

    local current_branch
    get_current_branch current_branch

    [ "$current_branch" = "release/1.0.0" ]
}

@test "get_current_branch: nameref parameter works correctly" {
    git checkout -b test-branch -q

    # Test with different variable names
    local my_branch
    get_current_branch my_branch
    [ "$my_branch" = "test-branch" ]

    local another_var
    get_current_branch another_var
    [ "$another_var" = "test-branch" ]
}
