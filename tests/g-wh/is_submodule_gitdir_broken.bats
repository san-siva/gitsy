#!/usr/bin/env bats

# Tests for is_submodule_gitdir_broken in g-wh

setup() {
    export TEST_DIR="$(mktemp -d)"
    cd "$TEST_DIR"

    source "${BATS_TEST_DIRNAME}/../../bin/utils"
    source "${BATS_TEST_DIRNAME}/../../bin/g-wh"
}

teardown() {
    rm -rf "$TEST_DIR"
}

@test "is_submodule_gitdir_broken: not created yet is not broken" {
    run is_submodule_gitdir_broken "$TEST_DIR/does-not-exist"
    [ "$status" -eq 1 ]
}

@test "is_submodule_gitdir_broken: config-only stub is broken" {
    local gitdir="$TEST_DIR/stub"
    mkdir -p "$gitdir"
    echo "[core]" >"$gitdir/config"

    run is_submodule_gitdir_broken "$gitdir"
    [ "$status" -eq 0 ]
}

@test "is_submodule_gitdir_broken: missing objects dir is broken" {
    local gitdir="$TEST_DIR/stub2"
    mkdir -p "$gitdir"
    touch "$gitdir/HEAD"

    run is_submodule_gitdir_broken "$gitdir"
    [ "$status" -eq 0 ]
}

@test "is_submodule_gitdir_broken: missing HEAD file is broken" {
    local gitdir="$TEST_DIR/stub3"
    mkdir -p "$gitdir/objects"

    run is_submodule_gitdir_broken "$gitdir"
    [ "$status" -eq 0 ]
}

@test "is_submodule_gitdir_broken: complete gitdir is healthy" {
    local gitdir="$TEST_DIR/healthy"
    mkdir -p "$gitdir/objects"
    touch "$gitdir/HEAD"

    run is_submodule_gitdir_broken "$gitdir"
    [ "$status" -eq 1 ]
}
