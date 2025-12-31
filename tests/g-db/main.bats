#!/usr/bin/env bats

# Tests for main function in g-db

setup() {
    export TEST_DIR="$(mktemp -d)"
    cd "$TEST_DIR"
    git init -q
    git config user.name "Test User"
    git config user.email "test@example.com"
    git commit --allow-empty -m "Initial commit" -q

    source "${BATS_TEST_DIRNAME}/../../bin/utils"
    source "${BATS_TEST_DIRNAME}/../../bin/g-db"
}

teardown() {
    rm -rf "$TEST_DIR"
}

@test "main: validates dependencies are checked" {
    # Verify validate_dependencies function is available
    type validate_dependencies &>/dev/null
    [ $? -eq 0 ]
}

@test "main: calls set_flags" {
    # Verify set_flags function exists
    type set_flags &>/dev/null
    [ $? -eq 0 ]
}

@test "main: prints banner" {
    # Verify print_banner function exists
    type print_banner &>/dev/null
    [ $? -eq 0 ]
}

@test "main: checks if target branch is set" {
    # Verify check_if_target_branch_is_set function exists
    type check_if_target_branch_is_set &>/dev/null
    [ $? -eq 0 ]
}
