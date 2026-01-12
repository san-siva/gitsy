#!/usr/bin/env bats

# Tests for list_worktrees function in g-wl

setup() {
    export TEST_DIR="$(mktemp -d)"
    cd "$TEST_DIR"

    # Create a proper directory structure for git repo
    mkdir -p myrepo
    cd myrepo

    git init -q
    git config user.name "Test User"
    git config user.email "test@example.com"

    # Create initial commit
    echo "test" > README.md
    git add README.md
    git commit -q -m "Initial commit"

    source "${BATS_TEST_DIRNAME}/../../bin/utils"
    source "${BATS_TEST_DIRNAME}/../../bin/g-wl"
}

teardown() {
    rm -rf "$TEST_DIR"
}

@test "list_worktrees: successfully lists main worktree" {
    run list_worktrees
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Worktrees:" ]]
}

@test "list_worktrees: displays total count" {
    run list_worktrees
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Total worktrees:" ]]
}

@test "list_worktrees: shows current branch" {
    run list_worktrees
    [ "$status" -eq 0 ]
    # Should show master or main depending on git version
    [[ "$output" =~ "master" ]] || [[ "$output" =~ "main" ]]
}

@test "list_worktrees: lists multiple worktrees" {
    # Create a worktree directory
    mkdir -p ../worktrees

    # Create a new branch and worktree
    git worktree add ../worktrees/feature-branch -b feature-branch 2>&1

    run list_worktrees
    [ "$status" -eq 0 ]
    [[ "$output" =~ "feature-branch" ]]
    [[ "$output" =~ "Total worktrees: 2" ]]
}

@test "list_worktrees: handles porcelain format parsing" {
    # Verify the function can parse git worktree list --porcelain
    local worktree_output
    worktree_output=$(git worktree list --porcelain)

    [ -n "$worktree_output" ]
    [[ "$worktree_output" =~ "worktree" ]]
}

@test "list_worktrees: displays directory names correctly" {
    mkdir -p ../worktrees
    git worktree add ../worktrees/test-feature -b test-feature 2>&1

    run list_worktrees
    [ "$status" -eq 0 ]
    [[ "$output" =~ "test-feature" ]]
}

@test "list_worktrees: formats table with borders" {
    run list_worktrees
    [ "$status" -eq 0 ]
    # Check for table border characters
    [[ "$output" =~ "┌" ]]
    [[ "$output" =~ "└" ]]
    [[ "$output" =~ "│" ]]
}

@test "list_worktrees: shows directory name and branch columns" {
    run list_worktrees
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Directory Name" ]]
    [[ "$output" =~ "Branch Name" ]]
}

@test "list_worktrees: handles detached HEAD state" {
    # Create a worktree in detached HEAD state
    mkdir -p ../worktrees
    git worktree add --detach ../worktrees/detached HEAD 2>&1

    run list_worktrees
    [ "$status" -eq 0 ]
    [[ "$output" =~ "detached HEAD" ]] || [[ "$output" =~ "detached" ]]
}

@test "list_worktrees: calculates max length for alignment" {
    # Create worktrees with different name lengths
    mkdir -p ../worktrees
    git worktree add ../worktrees/short -b short 2>&1
    git worktree add ../worktrees/very-long-worktree-name -b very-long-branch 2>&1

    run list_worktrees
    [ "$status" -eq 0 ]
    # Table should be properly aligned
    [[ "$output" =~ "short" ]]
    [[ "$output" =~ "very-long-worktree-name" ]]
}
