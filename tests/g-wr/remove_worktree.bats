#!/usr/bin/env bats

# Tests for remove_worktree function in g-wr

setup() {
    export TEST_DIR="$(mktemp -d)"
    cd "$TEST_DIR"

    # Set up main repo in a main/ subdirectory (gitsy worktree convention)
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

@test "remove_worktree: function exists" {
    type remove_worktree &>/dev/null
    [ $? -eq 0 ]
}

@test "remove_worktree: removes a clean worktree successfully" {
    local worktree_path
    worktree_path=$(cd "$TEST_DIR/worktrees" && pwd)/feature_branch

    cd "$TEST_DIR/main"
    git worktree add "$worktree_path" -b feature-branch -q 2>/dev/null || \
        git worktree add -b feature-branch "$worktree_path" -q 2>/dev/null || true

    if [ ! -d "$worktree_path" ]; then
        skip "Could not create test worktree"
    fi

    cd "$TEST_DIR/main"
    remove_worktree "$worktree_path" 1

    [ ! -d "$worktree_path" ]
}

@test "remove_worktree: falls back to manual removal when git worktree remove fails" {
    # Create a directory that looks like a worktree path but git doesn't know about it
    local fake_worktree
    fake_worktree=$(cd "$TEST_DIR/worktrees" && pwd)/fake_worktree
    mkdir -p "$fake_worktree"
    touch "$fake_worktree/untracked_file.txt"

    cd "$TEST_DIR/main"
    # Stub git to simulate failure on worktree remove but succeed on prune
    git() {
        if [[ "$*" == *"worktree remove"* ]]; then
            return 1
        fi
        command git "$@"
    }
    export -f git

    remove_worktree "$fake_worktree" 1

    [ ! -d "$fake_worktree" ]
}

@test "remove_worktree: removes worktree with untracked files using double force" {
    local worktree_path
    worktree_path=$(cd "$TEST_DIR/worktrees" && pwd)/untracked_test

    cd "$TEST_DIR/main"
    git worktree add "$worktree_path" -b untracked-test -q 2>/dev/null || \
        git worktree add -b untracked-test "$worktree_path" -q 2>/dev/null || true

    if [ ! -d "$worktree_path" ]; then
        skip "Could not create test worktree"
    fi

    # Add untracked files to the worktree (these block single --force removal)
    touch "$worktree_path/untracked1.txt"
    touch "$worktree_path/untracked2.txt"

    cd "$TEST_DIR/main"
    remove_worktree "$worktree_path" 1

    [ ! -d "$worktree_path" ]
}

@test "remove_worktree: CWD is navigated to parent after removing the worktree you are running from inside" {
    local worktrees_dir
    worktrees_dir=$(cd "$TEST_DIR/worktrees" && pwd)
    local worktree_path="$worktrees_dir/inside_worktree_test"

    cd "$TEST_DIR/main"
    git worktree add "$worktree_path" -b inside-worktree-test -q 2>/dev/null || \
        git worktree add -b inside-worktree-test "$worktree_path" -q 2>/dev/null || true

    if [ ! -d "$worktree_path" ]; then
        skip "Could not create test worktree"
    fi

    # Simulate running from inside the worktree
    cd "$worktree_path"

    remove_worktree "$worktree_path" 1

    # Worktree must be gone
    [ ! -d "$worktree_path" ]
    # CWD must have been moved to the parent (worktrees dir) — not left in deleted dir
    [ "$(pwd)" = "$worktrees_dir" ]
}
