#!/usr/bin/env bats

# Tests for main function in g-wl

setup() {
    export TEST_DIR="$(mktemp -d)"
    cd "$TEST_DIR"
    git init -q
    git config user.name "Test User"
    git config user.email "test@example.com"
    git commit --allow-empty -m "Initial commit" -q

    source "${BATS_TEST_DIRNAME}/../../bin/utils"
    source "${BATS_TEST_DIRNAME}/../../bin/g-wl"
}

teardown() {
    rm -rf "$TEST_DIR"
}

@test "main: validates dependencies" {
    type validate_dependencies &>/dev/null
    [ $? -eq 0 ]
}

@test "main: calls print_banner" {
    type print_banner &>/dev/null
    [ $? -eq 0 ]
}

@test "main: calls list_worktrees" {
    type list_worktrees &>/dev/null
    [ $? -eq 0 ]
}

@test "main: parses --help option" {
    run set_flags "--help"
    [ "$status" -eq 0 ]
}

@test "main: rejects unknown options" {
    run set_flags "--unknown-option"
    [ "$status" -eq 1 ]
    [[ "$output" =~ "Unknown option" ]]
}
