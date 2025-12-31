#!/usr/bin/env bats

# Tests for prompt_remote_deletion function in g-db

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

@test "prompt_remote_deletion: returns success when no remote branch exists" {
    git checkout -b test-branch -q

    prompt_remote_deletion "test-branch"
    [ $? -eq 0 ]
}

@test "prompt_remote_deletion: checks branch_exists_on_remote" {
    git checkout -b test-branch -q

    # Should return successfully when branch doesn't exist on remote
    prompt_remote_deletion "test-branch"
    [ $? -eq 0 ]
}
