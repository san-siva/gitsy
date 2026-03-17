#!/usr/bin/env bats

# Tests for set_flags function in g-pull

setup() {
    export TEST_DIR="$(mktemp -d)"
    cd "$TEST_DIR"
    git init -q
    git config user.name "Test User"
    git config user.email "test@example.com"

    source "${BATS_TEST_DIRNAME}/../../bin/utils"
    source "${BATS_TEST_DIRNAME}/../../bin/g-pull"
}

teardown() {
    rm -rf "$TEST_DIR"
}

@test "set_flags: -t sets target_branch" {
    target_branch=""
    set_flags -t my-branch
    [ "$target_branch" = "my-branch" ]
}

@test "set_flags: --target-branch sets target_branch" {
    target_branch=""
    set_flags --target-branch my-branch
    [ "$target_branch" = "my-branch" ]
}

@test "set_flags: -t= sets target_branch" {
    target_branch=""
    set_flags -t=my-branch
    [ "$target_branch" = "my-branch" ]
}

@test "set_flags: --target-branch= sets target_branch" {
    target_branch=""
    set_flags --target-branch=my-branch
    [ "$target_branch" = "my-branch" ]
}

@test "set_flags: -t without value exits 1" {
    run set_flags -t
    [ "$status" -eq 1 ]
}

@test "set_flags: --target-branch without value exits 1" {
    run set_flags --target-branch
    [ "$status" -eq 1 ]
}

@test "set_flags: -f sets do_fetch to true" {
    do_fetch=false
    set_flags -f
    [ "$do_fetch" = "true" ]
}

@test "set_flags: --fetch sets do_fetch to true" {
    do_fetch=false
    set_flags --fetch
    [ "$do_fetch" = "true" ]
}

@test "set_flags: -f and -t can be combined" {
    target_branch=""
    do_fetch=false
    set_flags -f -t my-branch
    [ "$target_branch" = "my-branch" ]
    [ "$do_fetch" = "true" ]
}

@test "set_flags: -h exits 0" {
    run set_flags -h
    [ "$status" -eq 0 ]
}

@test "set_flags: --help exits 0" {
    run set_flags --help
    [ "$status" -eq 0 ]
}

@test "set_flags: no flags leaves target_branch empty" {
    target_branch=""
    set_flags
    [ -z "$target_branch" ]
}

@test "set_flags: no flags leaves do_fetch false" {
    do_fetch=false
    set_flags
    [ "$do_fetch" = "false" ]
}
