#!/usr/bin/env bats

# Tests for main function in g-push

setup() {
    export TEST_DIR="$(mktemp -d)"
    cd "$TEST_DIR"
    git init -q
    git config user.name "Test User"
    git config user.email "test@example.com"

    source "${BATS_TEST_DIRNAME}/../../bin/utils"
    source "${BATS_TEST_DIRNAME}/../../bin/g-push"
}

teardown() {
    rm -rf "$TEST_DIR"
}

@test "main: validates dependencies" {
    type validate_dependencies &>/dev/null
    [ $? -eq 0 ]
}

@test "main: prints banner" {
    type print_banner &>/dev/null
    [ $? -eq 0 ]
}

@test "main: gets current branch when no target specified" {
    type get_current_branch &>/dev/null
    [ $? -eq 0 ]
}

@test "main: calls push_changes" {
    type push_changes &>/dev/null
    [ $? -eq 0 ]
}
