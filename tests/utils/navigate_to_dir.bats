#!/usr/bin/env bats

# Tests for navigate_to_dir function

setup() {
    export TEST_DIR="$(mktemp -d)"
    cd "$TEST_DIR"

    source "${BATS_TEST_DIRNAME}/../../bin/utils"
}

teardown() {
    rm -rf "$TEST_DIR"
}

@test "navigate_to_dir: function exists" {
    type navigate_to_dir &>/dev/null
    [ $? -eq 0 ]
}

@test "navigate_to_dir: returns 1 for empty input" {
    run navigate_to_dir ""
    [ "$status" -eq 1 ]
}

@test "navigate_to_dir: returns 1 for non-existent directory" {
    run navigate_to_dir "/nonexistent/path/that/does/not/exist"
    [ "$status" -eq 1 ]
}

@test "navigate_to_dir: returns 0 and changes CWD to target directory" {
    local target_dir="$TEST_DIR/subdir"
    mkdir -p "$target_dir"

    navigate_to_dir "$target_dir"
    [ $? -eq 0 ]
    [ "$(pwd)" = "$target_dir" ]
}

@test "navigate_to_dir: returns 0 when already in target directory" {
    navigate_to_dir "$TEST_DIR"
    [ $? -eq 0 ]
    [ "$(pwd)" = "$TEST_DIR" ]
}

@test "navigate_to_dir: does not return early when current path contains target as substring" {
    # This is the core bug fix: being inside /worktrees/some_worktree should NOT
    # cause navigate_to_dir "/worktrees" to skip the cd and stay in the subdirectory
    local worktrees_dir="$TEST_DIR/worktrees"
    local worktree_dir="$worktrees_dir/some_feature_branch"
    mkdir -p "$worktree_dir"

    cd "$worktree_dir"

    navigate_to_dir "$worktrees_dir"
    [ $? -eq 0 ]
    [ "$(pwd)" = "$worktrees_dir" ]
}

@test "navigate_to_dir: navigates up from deeply nested subdirectory" {
    local deep_dir="$TEST_DIR/a/b/c/d"
    mkdir -p "$deep_dir"
    cd "$deep_dir"

    navigate_to_dir "$TEST_DIR/a"
    [ $? -eq 0 ]
    [ "$(pwd)" = "$TEST_DIR/a" ]
}

@test "navigate_to_dir: resolves relative paths" {
    local subdir="$TEST_DIR/subdir"
    mkdir -p "$subdir"
    cd "$TEST_DIR"

    navigate_to_dir "subdir"
    [ $? -eq 0 ]
    [ "$(pwd)" = "$subdir" ]
}
