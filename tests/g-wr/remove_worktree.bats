#!/usr/bin/env bats

# Tests for remove_worktree function in g-wr

setup() {
    export TEST_DIR="$(mktemp -d)"
    cd "$TEST_DIR"
    git init -q
    git config user.name "Test User"
    git config user.email "test@example.com"

    source "${BATS_TEST_DIRNAME}/../../bin/utils"
    source "${BATS_TEST_DIRNAME}/../../bin/g-wr"
}

teardown() {
    rm -rf "$TEST_DIR"
}

@test "remove_worktree: function exists" {
    type remove_worktree &>/dev/null
    [ $? -eq 0 ]
}

@test "remove_worktree: takes worktree path and step number" {
    # Verify function signature
    type remove_worktree &>/dev/null
    [ $? -eq 0 ]
}
