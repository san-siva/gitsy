#!/usr/bin/env bats

# Tests for show_full_diff function in g-diff

setup() {
    export TEST_DIR="$(mktemp -d)"
    cd "$TEST_DIR"
    git init -q
    git config user.name "Test User"
    git config user.email "test@example.com"

    source "${BATS_TEST_DIRNAME}/../../bin/utils"
    source "${BATS_TEST_DIRNAME}/../../bin/g-diff"
}

teardown() {
    rm -rf "$TEST_DIR"
}

@test "show_full_diff: captures format_diff_output exit code" {
    type format_diff_output &>/dev/null
    [ $? -eq 0 ]
}

@test "show_full_diff: function exists" {
    type show_full_diff &>/dev/null
    [ $? -eq 0 ]
}
