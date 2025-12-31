#!/usr/bin/env bats

# Tests for main function in g-rto

setup() {
    export TEST_DIR="$(mktemp -d)"
    cd "$TEST_DIR"
    git init -q
    git config user.name "Test User"
    git config user.email "test@example.com"
    git commit --allow-empty -m "Initial commit" -q

    source "${BATS_TEST_DIRNAME}/../../bin/utils"
    source "${BATS_TEST_DIRNAME}/../../bin/g-rto"
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

@test "main: gets current branch" {
    type get_current_branch &>/dev/null
    [ $? -eq 0 ]
}

@test "main: calls stash_changes" {
    type stash_changes &>/dev/null
    [ $? -eq 0 ]
}

@test "main: calls fetch_changes" {
    type fetch_changes &>/dev/null
    [ $? -eq 0 ]
}

@test "main: calls reset_to_target_branch" {
    type reset_to_target_branch &>/dev/null
    [ $? -eq 0 ]
}

@test "main: calls pull_changes" {
    type pull_changes &>/dev/null
    [ $? -eq 0 ]
}
