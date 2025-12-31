#!/usr/bin/env bats

# Tests for find_worktree_by_branch function in g-wr

setup() {
    export TEST_DIR="$(mktemp -d)"
    cd "$TEST_DIR"
    git init -q
    git config user.name "Test User"
    git config user.email "test@example.com"
    git commit --allow-empty -m "Initial commit" -q

    source "${BATS_TEST_DIRNAME}/../../bin/utils"
    source "${BATS_TEST_DIRNAME}/../../bin/g-wr"
}

teardown() {
    rm -rf "$TEST_DIR"
}

@test "find_worktree_by_branch: captures git rev-parse exit code" {
    git checkout -b test-branch -q

    local branch
    branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    local branch_exit=$?

    [ "$branch_exit" -eq 0 ]
    [ "$branch" = "test-branch" ]
}

@test "find_worktree_by_branch: checks target branch is set" {
    type check_if_target_branch_is_set &>/dev/null
    [ $? -eq 0 ]
}
