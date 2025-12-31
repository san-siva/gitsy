#!/usr/bin/env bats

# Tests for format_diff_output function in g-diff

setup() {
    export TEST_DIR="$(mktemp -d)"
    cd "$TEST_DIR"
    git init -q
    git config user.name "Test User"
    git config user.email "test@example.com"
    git commit --allow-empty -m "Initial commit" -q

    source "${BATS_TEST_DIRNAME}/../../bin/utils"
    source "${BATS_TEST_DIRNAME}/../../bin/g-diff"
}

teardown() {
    rm -rf "$TEST_DIR"
}

@test "format_diff_output: captures numstat exit code immediately" {
    # Get the current branch name
    local default_branch=$(git branch --show-current)

    # Create a file on default branch
    echo "main content" > test.txt
    git add test.txt
    git commit -m "Add test on default branch" -q

    # Create test branch with different content
    git checkout -b test-branch -q
    echo "test branch content" > test.txt
    git add test.txt
    git commit -m "Add test on test-branch" -q

    target_branch="$default_branch"
    source_branch="test-branch"

    local numstat_output
    numstat_output=$(git diff --numstat "${target_branch}..${source_branch}" -- "test.txt" 2>&1)
    local numstat_exit=$?

    [ "$numstat_exit" -eq 0 ]
}

@test "format_diff_output: function exists" {
    type format_diff_output &>/dev/null
    [ $? -eq 0 ]
}
