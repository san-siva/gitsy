#!/usr/bin/env bats

# Tests for repair_broken_submodule in g-wh

setup() {
    export TEST_DIR="$(mktemp -d)"
    # repair_broken_submodule shells out to plain `git submodule update`
    # (no -c protocol.file.allow), so allow local file:// clones for the
    # duration of this test process only.
    export GIT_ALLOW_PROTOCOL="file:git:http:https:ssh"

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
    (cd "$worktree_path" && git -c protocol.file.allow=always submodule update --init --recursive -q)

    source "${BATS_TEST_DIRNAME}/../../bin/utils"
    source "${BATS_TEST_DIRNAME}/../../bin/g-wh"

    local git_dir common_dir
    resolve_worktree_dirs "$worktree_path" git_dir common_dir
    submodule_gitdir="$common_dir/worktrees/$(basename "$git_dir")/modules/external/sub"

    # Break it: leave only the config stub, as an interrupted setup would.
    find "$submodule_gitdir" -mindepth 1 -not -name config -exec rm -rf {} + 2>/dev/null || true
}

teardown() {
    rm -rf "$TEST_DIR"
}

@test "repair_broken_submodule: recreates a working gitdir" {
    run repair_broken_submodule "$worktree_path" "external/sub" "$submodule_gitdir" 0
    [ "$status" -eq 0 ]

    [ -f "$submodule_gitdir/HEAD" ]
    [ -d "$submodule_gitdir/objects" ]
}

@test "repair_broken_submodule: submodule working directory has its files back" {
    run repair_broken_submodule "$worktree_path" "external/sub" "$submodule_gitdir" 0
    [ "$status" -eq 0 ]

    [ -f "$worktree_path/external/sub/file.txt" ]
}

@test "repair_broken_submodule: healed submodule is no longer reported as broken" {
    repair_broken_submodule "$worktree_path" "external/sub" "$submodule_gitdir" 0

    local -a broken_paths broken_gitdirs
    find_broken_submodules "$worktree_path" broken_paths broken_gitdirs

    [ ${#broken_paths[@]} -eq 0 ]
}
