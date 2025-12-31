#!/usr/bin/env bats

# Tests for delete_local_branch function in g-db

setup() {
    export TEST_DIR="$(mktemp -d)"
    cd "$TEST_DIR"
    git init -q
    git config user.name "Test User"
    git config user.email "test@example.com"
    git commit --allow-empty -m "Initial commit" -q

    source "${BATS_TEST_DIRNAME}/../../bin/utils"
    source "${BATS_TEST_DIRNAME}/../../bin/g-db"
}

teardown() {
    rm -rf "$TEST_DIR"
}

@test "delete_local_branch: deletes existing branch" {
    # Get the default branch name
    local default_branch=$(git branch --show-current)

    git checkout -b test-branch -q
    git checkout "$default_branch" -q

    delete_local_branch "test-branch"

    # Branch should no longer exist
    ! git show-ref --verify --quiet "refs/heads/test-branch"
}

@test "delete_local_branch: returns success for non-existent branch" {
    delete_local_branch "non-existent-branch"
    [ $? -eq 0 ]
}

@test "delete_local_branch: prevents deletion of current branch" {
    git checkout -b current-branch -q

    run delete_local_branch "current-branch"
    [ "$status" -eq 1 ]
    [[ "$output" == *"Cannot delete the branch you are currently on"* ]]
}

@test "delete_local_branch: uses get_current_branch correctly" {
    # Get the default branch name
    local default_branch=$(git branch --show-current)

    git checkout -b test-branch -q
    git checkout "$default_branch" -q

    local current
    get_current_branch current
    [ "$current" = "$default_branch" ]

    delete_local_branch "test-branch"
    [ $? -eq 0 ]
}
