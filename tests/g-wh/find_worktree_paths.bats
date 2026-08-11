#!/usr/bin/env bats

# Tests for find_worktree_paths in g-wh

setup() {
    export TEST_DIR="$(cd "$(mktemp -d)" && pwd -P)"
    mkdir -p "$TEST_DIR/main"
    cd "$TEST_DIR/main"
    git init -q
    git config user.name "Test User"
    git config user.email "test@example.com"
    git commit --allow-empty -m "Initial commit" -q

    source "${BATS_TEST_DIRNAME}/../../bin/utils"
    source "${BATS_TEST_DIRNAME}/../../bin/g-wh"
}

teardown() {
    rm -rf "$TEST_DIR"
}

@test "find_worktree_paths: lists the main worktree alone" {
    local -a paths
    find_worktree_paths paths

    [ ${#paths[@]} -eq 1 ]
    [ "${paths[0]}" = "$TEST_DIR/main" ]
}

@test "find_worktree_paths: includes linked worktrees" {
    mkdir -p "$TEST_DIR/worktrees"
    git worktree add "$TEST_DIR/worktrees/feature" -b feature -q 2>/dev/null || \
        git worktree add -b feature "$TEST_DIR/worktrees/feature" -q

    local -a paths
    find_worktree_paths paths

    [ ${#paths[@]} -eq 2 ]
    [[ " ${paths[*]} " == *" $TEST_DIR/worktrees/feature "* ]]
}
