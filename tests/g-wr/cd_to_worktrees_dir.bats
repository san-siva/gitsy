#!/usr/bin/env bats

# Tests for cd_to_worktrees_dir function in g-wr

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

@test "cd_to_worktrees_dir: captures git rev-parse exit code immediately" {
    local git_root
    git_root=$(git rev-parse --show-toplevel 2>&1)
    local root_exit=$?

    [ "$root_exit" -eq 0 ]
    [ -n "$git_root" ]
}

@test "cd_to_worktrees_dir: gets git root correctly" {
    local git_root
    git_root=$(git rev-parse --show-toplevel)

    [ -n "$git_root" ]
    [ -d "$git_root" ]
}

@test "cd_to_worktrees_dir: navigates to worktrees dir when called from main repo" {
    # Set up: main repo with a sibling worktrees directory
    local main_dir="$TEST_DIR/main"
    # Resolve canonical physical paths (macOS /var -> /private/var symlink)
    local worktrees_dir
    mkdir -p "$main_dir" "$TEST_DIR/worktrees"
    worktrees_dir=$(cd "$TEST_DIR/worktrees" && pwd -P)

    cd "$main_dir"
    git init -q
    git config user.name "Test User"
    git config user.email "test@example.com"

    cd_to_worktrees_dir
    # Use pwd -P to resolve symlinks (macOS: /var is a symlink to /private/var)
    [ "$(pwd -P)" = "$worktrees_dir" ]
}

@test "cd_to_worktrees_dir: navigates to worktrees dir when called from inside a worktree" {
    # This is the key scenario: running g-wr from inside the worktree you want to remove.
    # The bug was that navigate_to_dir used substring matching, so being inside
    # /worktrees/my_feature caused it to skip the cd and stay in the subdirectory.
    local main_dir="$TEST_DIR/main"
    local worktree_dir="$TEST_DIR/worktrees/my_feature_branch"
    # Resolve canonical physical paths (macOS /var -> /private/var symlink)
    local worktrees_dir
    mkdir -p "$main_dir" "$worktree_dir"
    worktrees_dir=$(cd "$TEST_DIR/worktrees" && pwd -P)
    local worktree_dir_resolved
    worktree_dir_resolved=$(cd "$worktree_dir" && pwd -P)

    cd "$main_dir"
    git init -q
    git config user.name "Test User"
    git config user.email "test@example.com"
    git commit --allow-empty -m "Initial commit" -q

    git worktree add "$worktree_dir_resolved" -b my-feature -q 2>/dev/null || true

    # Simulate being inside the worktree
    cd "$worktree_dir_resolved"

    cd_to_worktrees_dir

    # Must land in worktrees/, NOT stay in the worktree subdirectory
    # Use pwd -P to resolve symlinks (macOS: /var is a symlink to /private/var)
    [ "$(pwd -P)" = "$worktrees_dir" ]
}

@test "cd_to_worktrees_dir: fails when worktrees directory does not exist" {
    # In a plain git repo with no sibling worktrees/ dir, it should fail
    local plain_dir="$TEST_DIR/plain"
    mkdir -p "$plain_dir"
    cd "$plain_dir"
    git init -q
    git config user.name "Test User"
    git config user.email "test@example.com"

    run cd_to_worktrees_dir
    [ "$status" -ne 0 ]
}
