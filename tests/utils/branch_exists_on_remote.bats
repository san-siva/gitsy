#!/usr/bin/env bats

# Tests for branch_exists_on_remote function

setup() {
    export TEST_DIR="$(mktemp -d)"
    cd "$TEST_DIR"
    git init -q
    git config user.name "Test User"
    git config user.email "test@example.com"

    # Create initial commit so git operations work
    echo "test" > README.md
    git add README.md
    git commit -q -m "Initial commit"

    source "${BATS_TEST_DIRNAME}/../../bin/utils"
}

teardown() {
    rm -rf "$TEST_DIR"
}

@test "branch_exists_on_remote: returns false when no remote configured" {
    run branch_exists_on_remote "any-branch"
    [ "$status" -eq 1 ]
}

@test "branch_exists_on_remote: returns false for non-existent branch" {
    # Create a local bare repository to use as fake remote
    local remote_dir="$(mktemp -d)"
    git init --bare -q "$remote_dir"

    # Add the local repository as remote
    git remote add origin "$remote_dir"

    # Push current branch to create remote
    git push -q origin main:main 2>/dev/null || true

    # Test non-existent branch
    run branch_exists_on_remote "non-existent-branch"
    [ "$status" -eq 1 ]

    # Cleanup
    rm -rf "$remote_dir"
}
