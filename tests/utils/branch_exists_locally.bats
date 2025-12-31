#!/usr/bin/env bats

# Tests for branch_exists_locally function

setup() {
    export TEST_DIR="$(mktemp -d)"
    cd "$TEST_DIR"
    git init -q
    git config user.name "Test User"
    git config user.email "test@example.com"

    # Create initial commit so branches have refs
    echo "test" > README.md
    git add README.md
    git commit -q -m "Initial commit"

    source "${BATS_TEST_DIRNAME}/../../bin/utils"
}

teardown() {
    rm -rf "$TEST_DIR"
}

@test "branch_exists_locally: returns true for existing branch" {
    git checkout -b existing-branch -q

    branch_exists_locally "existing-branch"
    [ $? -eq 0 ]
}

@test "branch_exists_locally: returns false for non-existent branch" {
    run branch_exists_locally "non-existent-branch"
    [ "$status" -eq 1 ]
}

@test "branch_exists_locally: works with main branch" {
    git checkout -b main -q

    branch_exists_locally "main"
    [ $? -eq 0 ]
}

@test "branch_exists_locally: works with master branch" {
    # Check if master already exists, if not create it
    if ! git show-ref --verify --quiet refs/heads/master; then
        git checkout -b master -q
    fi

    branch_exists_locally "master"
    [ $? -eq 0 ]
}

@test "branch_exists_locally: works with feature branches" {
    git checkout -b feature/test -q

    branch_exists_locally "feature/test"
    [ $? -eq 0 ]
}

@test "branch_exists_locally: case sensitivity depends on filesystem" {
    git checkout -b TestBranch -q

    branch_exists_locally "TestBranch"
    [ $? -eq 0 ]

    # On case-insensitive filesystems (macOS APFS), this will also match
    # On case-sensitive filesystems (most Linux), this will not match
    # Just verify the function runs without error
    run branch_exists_locally "testbranch"
    [ "$status" -eq 0 ] || [ "$status" -eq 1 ]
}
