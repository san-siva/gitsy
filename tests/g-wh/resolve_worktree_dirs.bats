#!/usr/bin/env bats

# Tests for resolve_worktree_dirs in g-wh

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

@test "resolve_worktree_dirs: main worktree has git_dir == common_dir" {
    local git_dir common_dir
    resolve_worktree_dirs "$TEST_DIR/main" git_dir common_dir

    [ -n "$git_dir" ]
    [ -n "$common_dir" ]
    [ "$git_dir" = "$common_dir" ]
}

@test "resolve_worktree_dirs: linked worktree has git_dir nested under common_dir/worktrees" {
    mkdir -p "$TEST_DIR/worktrees"
    local worktree_path="$TEST_DIR/worktrees/feature"

    git worktree add "$worktree_path" -b feature -q 2>/dev/null || \
        git worktree add -b feature "$worktree_path" -q 2>/dev/null

    [ -d "$worktree_path" ]

    local git_dir common_dir
    resolve_worktree_dirs "$worktree_path" git_dir common_dir

    [ -n "$git_dir" ]
    [ -n "$common_dir" ]
    [ "$git_dir" != "$common_dir" ]
    [ "$(dirname "$git_dir")" = "$common_dir/worktrees" ]
    [ "$common_dir" = "$TEST_DIR/main/.git" ]
}

@test "resolve_worktree_dirs: fails for a non-git directory" {
    mkdir -p "$TEST_DIR/not_a_repo"

    run resolve_worktree_dirs "$TEST_DIR/not_a_repo" git_dir common_dir
    [ "$status" -ne 0 ]
}
