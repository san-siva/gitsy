#!/usr/bin/env bats

# Tests for remove_all_worktrees in g-wr

setup() {
    export TEST_DIR="$(cd "$(mktemp -d)" && pwd -P)"

    # Set up main repo in a main/ subdirectory (gitsy convention)
    mkdir -p "$TEST_DIR/main"
    cd "$TEST_DIR/main"
    git init -q
    git config user.name "Test User"
    git config user.email "test@example.com"
    git commit --allow-empty -m "Initial commit" -q

    mkdir -p "$TEST_DIR/worktrees"

    source "${BATS_TEST_DIRNAME}/../../bin/utils"
    source "${BATS_TEST_DIRNAME}/../../bin/g-wr"
}

teardown() {
    rm -rf "$TEST_DIR"
}

@test "remove_all_worktrees: function exists" {
    type remove_all_worktrees &>/dev/null
    [ $? -eq 0 ]
}

@test "remove_all_worktrees: removes all worktrees except main" {
    cd "$TEST_DIR/main"
    git worktree add "$TEST_DIR/worktrees/wt1" -b wt1 -q
    git worktree add "$TEST_DIR/worktrees/wt2" -b wt2 -q

    [ -d "$TEST_DIR/worktrees/wt1" ]
    [ -d "$TEST_DIR/worktrees/wt2" ]

    FORCE=true
    run remove_all_worktrees 1
    [ "$status" -eq 0 ]

    [ ! -d "$TEST_DIR/worktrees/wt1" ]
    [ ! -d "$TEST_DIR/worktrees/wt2" ]
    [ -d "$TEST_DIR/main" ]

    # Main worktree must still be intact
    cd "$TEST_DIR/main"
    local current_branch
    current_branch=$(git rev-parse --abbrev-ref HEAD)
    [ -n "$current_branch" ]
}

@test "remove_all_worktrees: cleans up stale worktrees whose directory was already removed" {
    cd "$TEST_DIR/main"
    git worktree add "$TEST_DIR/worktrees/stale1" -b stale1 -q

    # Delete directory manually
    rm -rf "$TEST_DIR/worktrees/stale1"

    # Git still lists it as prunable
    local porcelain
    porcelain=$(git worktree list --porcelain)
    [[ "$porcelain" =~ "stale1" ]]

    FORCE=true
    run remove_all_worktrees 1
    [ "$status" -eq 0 ]

    # After remove_all_worktrees, git should have pruned it
    porcelain=$(git worktree list --porcelain)
    [[ ! "$porcelain" =~ "stale1" ]]
}

@test "remove_all_worktrees: succeeds with message when only main exists" {
    cd "$TEST_DIR/main"

    FORCE=true
    run remove_all_worktrees 1
    [ "$status" -eq 0 ]
    [[ "$output" =~ "No worktrees found to remove" ]]
}

@test "remove_all_worktrees: cancels when user answers n" {
    cd "$TEST_DIR/main"
    git worktree add "$TEST_DIR/worktrees/wt_keep" -b wt_keep -q

    FORCE=false
    prompt_user() { echo "n"; }
    export -f prompt_user

    run remove_all_worktrees 1
    [ "$status" -eq 0 ]
    [[ "$output" =~ "cancelled" ]]
    [ -d "$TEST_DIR/worktrees/wt_keep" ]
}
