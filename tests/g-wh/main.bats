#!/usr/bin/env bats

# Tests for main function in g-wh

setup() {
    export TEST_DIR="$(mktemp -d)"
    cd "$TEST_DIR"
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

@test "main: validates dependencies" {
    type validate_dependencies &>/dev/null
    [ $? -eq 0 ]
}

@test "main: prints banner" {
    type print_banner &>/dev/null
    [ $? -eq 0 ]
}

@test "main: calls heal_worktree" {
    type heal_worktree &>/dev/null
    [ $? -eq 0 ]
}

@test "main: calls find_worktree_paths" {
    type find_worktree_paths &>/dev/null
    [ $? -eq 0 ]
}

@test "main: with no flags, heals the current directory and reports no issues in a clean repo" {
    run main --dry-run
    [ "$status" -eq 0 ]
    [[ "$output" == *"No broken submodule gitdirs found"* ]]
}

@test "main: --all with no worktrees found still succeeds against the sole main worktree" {
    run main --all --dry-run
    [ "$status" -eq 0 ]
}

@test "main: -w with an unknown worktree name fails" {
    run main -w does-not-exist --dry-run
    [ "$status" -eq 1 ]
}
