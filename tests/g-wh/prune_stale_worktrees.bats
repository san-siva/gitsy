#!/usr/bin/env bats

# Tests for find_prunable_worktrees and prune_stale_worktrees in g-wh

setup() {
    export TEST_DIR="$(cd "$(mktemp -d)" && pwd -P)"
    mkdir -p "$TEST_DIR/main"
    cd "$TEST_DIR/main"
    git init -q
    git config user.name "Test User"
    git config user.email "test@example.com"
    git commit --allow-empty -m "Initial commit" -q

    mkdir -p "$TEST_DIR/worktrees"

    source "${BATS_TEST_DIRNAME}/../../bin/utils"
    source "${BATS_TEST_DIRNAME}/../../bin/g-wh"
}

teardown() {
    rm -rf "$TEST_DIR"
}

@test "find_prunable_worktrees: empty when all worktrees exist on disk" {
    cd "$TEST_DIR/main"
    git worktree add "$TEST_DIR/worktrees/healthy" -b healthy -q

    local -a paths branches
    find_prunable_worktrees paths branches

    [ ${#paths[@]} -eq 0 ]
}

@test "find_prunable_worktrees: finds worktree whose directory was deleted on disk" {
    cd "$TEST_DIR/main"
    git worktree add "$TEST_DIR/worktrees/to_delete" -b to_delete -q

    # Manually delete directory
    rm -rf "$TEST_DIR/worktrees/to_delete"

    local -a paths branches
    find_prunable_worktrees paths branches

    [ ${#paths[@]} -eq 1 ]
    [ "${paths[0]}" = "$TEST_DIR/worktrees/to_delete" ]
    [ "${branches[0]}" = "to_delete" ]
}

@test "prune_stale_worktrees: prunes stale worktrees from git records when confirmed" {
    cd "$TEST_DIR/main"
    git worktree add "$TEST_DIR/worktrees/ghost1" -b ghost1 -q
    rm -rf "$TEST_DIR/worktrees/ghost1"

    FORCE=true
    run prune_stale_worktrees 1
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Stale worktrees pruned successfully" ]]

    # Verify git worktree list no longer includes ghost1
    local porcelain
    porcelain=$(git worktree list --porcelain)
    [[ ! "$porcelain" =~ "ghost1" ]]
}

@test "prune_stale_worktrees: --dry-run reports would prune without removing" {
    cd "$TEST_DIR/main"
    git worktree add "$TEST_DIR/worktrees/ghost2" -b ghost2 -q
    rm -rf "$TEST_DIR/worktrees/ghost2"

    dry_run=true
    run prune_stale_worktrees 1
    [ "$status" -eq 0 ]
    [[ "$output" =~ "(dry-run) would prune" ]]

    # Git should still have the record
    local porcelain
    porcelain=$(git worktree list --porcelain)
    [[ "$porcelain" =~ "ghost2" ]]
}

@test "heal_worktree: prunes worktree whose directory does not exist on disk" {
    cd "$TEST_DIR/main"
    git worktree add "$TEST_DIR/worktrees/missing_dir" -b missing_dir -q
    rm -rf "$TEST_DIR/worktrees/missing_dir"

    FORCE=true
    run heal_worktree "$TEST_DIR/worktrees/missing_dir" 1
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Stale worktree pruned" ]]
}

@test "main: in main worktree, detects and auto-prunes stale worktree with force" {
    cd "$TEST_DIR/main"
    git worktree add "$TEST_DIR/worktrees/stale_repo" -b stale_repo -q
    rm -rf "$TEST_DIR/worktrees/stale_repo"

    FORCE=true
    run main
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Stale worktrees pruned successfully" ]]

    local porcelain
    porcelain=$(git worktree list --porcelain)
    [[ ! "$porcelain" =~ "stale_repo" ]]
}
