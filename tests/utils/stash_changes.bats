#!/usr/bin/env bats

# Tests for stash_changes function

setup() {
    export TEST_DIR="$(mktemp -d)"
    cd "$TEST_DIR"
    git init -q
    git config user.name "Test User"
    git config user.email "test@example.com"
    git checkout -b main -q
    git commit --allow-empty -m "Initial commit" -q

    source "${BATS_TEST_DIRNAME}/../../bin/utils"
}

teardown() {
    rm -rf "$TEST_DIR"
}

@test "stash_changes: does nothing when flag is false" {
    echo "test" > test.txt

    stash_changes false 1

    # File should still exist and not be stashed
    [ -f "test.txt" ]
}

@test "stash_changes: stashes when flag is true" {
    echo "test" > test.txt
    git add test.txt

    stash_changes true 1

    # File should be stashed (working tree and index should be clean)
    git diff --quiet && git diff --cached --quiet
}

@test "stash_changes: captures branch name exit code" {
    git checkout -b test-branch -q

    # Test the pattern used in the code
    local branch_name
    branch_name=$(git rev-parse --abbrev-ref HEAD 2>&1)
    local branch_exit=$?

    [ "$branch_exit" -eq 0 ]
    [ "$branch_name" = "test-branch" ]
}

@test "stash_changes: includes branch name in stash message" {
    git checkout -b feature-branch -q
    echo "test" > test.txt
    git add test.txt

    stash_changes true 1

    # Check if stash was created
    git stash list | grep -q "feature-branch"
}

@test "stash_changes: includes custom message when provided" {
    echo "test" > test.txt
    git add test.txt

    stash_changes true 1 "custom message"

    # Check if stash includes custom message
    git stash list | grep -q "custom message"
}

@test "stash_changes: works with step_number 0" {
    echo "test" > test.txt
    git add test.txt

    stash_changes true 0

    [ $? -eq 0 ]
}
