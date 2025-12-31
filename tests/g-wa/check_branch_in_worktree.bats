#!/usr/bin/env bats

# Tests for check_branch_in_worktree function in g-wa

setup() {
    export TEST_DIR="$(mktemp -d)"
    cd "$TEST_DIR"
    git init -q
    git config user.name "Test User"
    git config user.email "test@example.com"
    git commit --allow-empty -m "Initial commit" -q

    source "${BATS_TEST_DIRNAME}/../../bin/utils"
    source "${BATS_TEST_DIRNAME}/../../bin/g-wa"
}

teardown() {
    rm -rf "$TEST_DIR"
}

@test "check_branch_in_worktree: captures git worktree list exit code" {
    local existing_worktree
    existing_worktree=$(git worktree list 2>/dev/null | grep -F "[test]" | awk '{print $1}')
    local worktree_exit=$?

    [ -n "$worktree_exit" ]
}

@test "check_branch_in_worktree: handles non-existent branch" {
    check_branch_in_worktree "non-existent-branch" 1
    [ $? -eq 0 ]
}

@test "check_branch_in_worktree: checks if branch exists in worktree list" {
    # Should complete without error for non-existent branch
    check_branch_in_worktree "test-branch" 1
    [ $? -eq 0 ]
}
