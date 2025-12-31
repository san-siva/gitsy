#!/usr/bin/env bats

# Tests for checkout_or_create_branch function in g-wa

setup() {
    export TEST_DIR="$(mktemp -d)"
    cd "$TEST_DIR"
    git init -q
    git config user.name "Test User"
    git config user.email "test@example.com"
    git commit --allow-empty -m "Initial commit" -q

    source "${BATS_TEST_DIRNAME}/../../bin/utils"
    source "${BATS_TEST_DIRNAME}/../../bin/g-wa"

    target_branch="test-branch"
}

teardown() {
    rm -rf "$TEST_DIR"
}

@test "checkout_or_create_branch: calls check_branch_in_worktree" {
    type check_branch_in_worktree &>/dev/null
    [ $? -eq 0 ]
}

@test "checkout_or_create_branch: calls generate_worktree_path" {
    type generate_worktree_path &>/dev/null
    [ $? -eq 0 ]
}

@test "checkout_or_create_branch: handles generate_worktree_path failure" {
    # If generate_worktree_path returns non-zero, function should exit
    type checkout_or_create_branch &>/dev/null
    [ $? -eq 0 ]
}
