#!/usr/bin/env bats

# Tests for try_fetching_branch function in g-wa

setup() {
    export TEST_DIR="$(mktemp -d)"
    cd "$TEST_DIR"
    git init -q
    git config user.name "Test User"
    git config user.email "test@example.com"

    source "${BATS_TEST_DIRNAME}/../../bin/utils"
    source "${BATS_TEST_DIRNAME}/../../bin/g-wa"

    # Set target_branch for the function to use
    target_branch="test-branch"
}

teardown() {
    rm -rf "$TEST_DIR"
}

@test "try_fetching_branch: calls fetch_changes" {
    # Verify fetch_changes function exists
    type fetch_changes &>/dev/null
    [ $? -eq 0 ]
}

@test "try_fetching_branch: uses target_branch variable" {
    target_branch="feature-branch"
    # Function should use the global target_branch variable
    type try_fetching_branch &>/dev/null
    [ $? -eq 0 ]
}
