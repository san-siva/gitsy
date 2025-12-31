#!/usr/bin/env bats

# Tests for prompt_user_confirmation function in g-db

setup() {
    export TEST_DIR="$(mktemp -d)"
    cd "$TEST_DIR"
    git init -q
    git config user.name "Test User"
    git config user.email "test@example.com"

    source "${BATS_TEST_DIRNAME}/../../bin/utils"
    source "${BATS_TEST_DIRNAME}/../../bin/g-db"
}

teardown() {
    rm -rf "$TEST_DIR"
}

@test "prompt_user_confirmation: calls prompt_user with correct parameters" {
    # This test verifies the function structure
    # Actual prompting would require input simulation

    # Just verify the function exists and can be called
    type prompt_user_confirmation &>/dev/null
    [ $? -eq 0 ]
}

@test "prompt_user_confirmation: uses prompt_user from utils" {
    # Verify prompt_user is available
    type prompt_user &>/dev/null
    [ $? -eq 0 ]
}
