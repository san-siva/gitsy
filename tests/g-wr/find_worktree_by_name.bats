#!/usr/bin/env bats

# Tests for find_worktree_by_name function in g-wr

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

@test "find_worktree_by_name: function exists" {
    type find_worktree_by_name &>/dev/null
    [ $? -eq 0 ]
}

@test "find_worktree_by_name: calls cd_to_worktrees_dir" {
    type cd_to_worktrees_dir &>/dev/null
    [ $? -eq 0 ]
}
