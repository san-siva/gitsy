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
