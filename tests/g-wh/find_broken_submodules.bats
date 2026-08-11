#!/usr/bin/env bats

# Tests for find_broken_submodules in g-wh
# Exercises the real failure mode: a linked worktree's private submodule
# gitdir left as a config-only stub (as if setup was interrupted mid-merge).

setup() {
    export TEST_DIR="$(mktemp -d)"

    # Submodule source repo
    mkdir -p "$TEST_DIR/sub"
    (
        cd "$TEST_DIR/sub"
        git init -q
        git config user.name "Test User"
        git config user.email "test@example.com"
        echo "hello" >file.txt
        git add file.txt
        git commit -m "Initial commit" -q
    )

    # Main superproject with the submodule registered
    mkdir -p "$TEST_DIR/main"
    cd "$TEST_DIR/main"
    git init -q
    git config user.name "Test User"
    git config user.email "test@example.com"
    git -c protocol.file.allow=always submodule add -q "$TEST_DIR/sub" external/sub
    git commit -m "Add submodule" -q

    mkdir -p "$TEST_DIR/worktrees"
    worktree_path="$TEST_DIR/worktrees/feature"
    git worktree add "$worktree_path" -b feature -q 2>/dev/null || \
        git worktree add -b feature "$worktree_path" -q

    # Fully initialize the submodule in the worktree -> healthy baseline
    (cd "$worktree_path" && git -c protocol.file.allow=always submodule update --init --recursive -q)

    source "${BATS_TEST_DIRNAME}/../../bin/utils"
    source "${BATS_TEST_DIRNAME}/../../bin/g-wh"
}

teardown() {
    rm -rf "$TEST_DIR"
}

worktree_submodule_gitdir() {
    local git_dir common_dir
    resolve_worktree_dirs "$worktree_path" git_dir common_dir
    echo "$common_dir/worktrees/$(basename "$git_dir")/modules/external/sub"
}

@test "find_broken_submodules: healthy submodule is not reported" {
    local -a broken_paths broken_gitdirs
    find_broken_submodules "$worktree_path" broken_paths broken_gitdirs

    [ ${#broken_paths[@]} -eq 0 ]
}

@test "find_broken_submodules: detects a config-only stub gitdir" {
    local gitdir
    gitdir=$(worktree_submodule_gitdir)
    [ -d "$gitdir" ]

    # Simulate an interrupted setup: everything gone except config
    find "$gitdir" -mindepth 1 -not -name config -exec rm -rf {} + 2>/dev/null || true

    local -a broken_paths broken_gitdirs
    find_broken_submodules "$worktree_path" broken_paths broken_gitdirs

    [ ${#broken_paths[@]} -eq 1 ]
    [ "${broken_paths[0]}" = "external/sub" ]
    [ "${broken_gitdirs[0]}" = "$gitdir" ]
}

@test "find_broken_submodules: an uninitialized submodule (never set up) is not reported as broken" {
    # A second worktree where the submodule was never initialized at all
    local other_worktree="$TEST_DIR/worktrees/other"
    (cd "$TEST_DIR/main" && git worktree add "$other_worktree" -b other -q)

    local -a broken_paths broken_gitdirs
    find_broken_submodules "$other_worktree" broken_paths broken_gitdirs

    [ ${#broken_paths[@]} -eq 0 ]
}
