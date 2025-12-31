#!/usr/bin/env bats

# Test the g-wa (worktree add) script
setup() {
    # Set up test directory
    export TEST_DIR="$(mktemp -d)"
    cd "$TEST_DIR"
    git init -q
    git config user.name "Test User"
    git config user.email "test@example.com"
    git commit --allow-empty -m "Initial commit" -q

    # Source the required files
    source "${BATS_TEST_DIRNAME}/../bin/utils"
    source "${BATS_TEST_DIRNAME}/../bin/g-wa"
}

teardown() {
    # Clean up test directory
    rm -rf "$TEST_DIR"
}

# Test generate_worktree_path function
@test "generate_worktree_path: generates path correctly" {
    local result_path
    generate_worktree_path "feature/test-branch" result_path

    [ -n "$result_path" ]
    [[ "$result_path" == *"feature_test_branch"* ]]
}

@test "generate_worktree_path: returns via nameref correctly" {
    local my_path
    generate_worktree_path "test-branch" my_path

    # The crucial test: nameref should work and path should not be empty
    [ -n "$my_path" ]
    [ "$?" -eq 0 ]
}

@test "generate_worktree_path: no variable collision with nameref" {
    # This tests the bug fix where 'path' variable collided with nameref parameter
    local path
    generate_worktree_path "test-branch" path

    # Path should be set correctly despite the parameter name being 'path'
    [ -n "$path" ]
}

@test "generate_worktree_path: captures exit code from cd command" {
    # Create a valid directory structure first
    mkdir -p ../worktrees

    local result_path
    generate_worktree_path "test-branch" result_path
    local exit_code=$?

    [ "$exit_code" -eq 0 ]
    [ -n "$result_path" ]
}

@test "generate_worktree_path: handles long branch names" {
    local result_path
    generate_worktree_path "EXT-5994__template_changes_for_element_selectors__test_fix_dump" result_path

    [ -n "$result_path" ]
    # Should be sanitized and truncated
    [[ "$result_path" == *"ext_5994__template_changes_for"* ]]
}

@test "generate_worktree_path: generates unique path when directory exists" {
    mkdir -p ../worktrees
    local result_path

    # First call should create the base path
    generate_worktree_path "test-branch" result_path
    local first_path="$result_path"

    # Create the directory to simulate it existing
    mkdir -p "$first_path"

    # Second call should generate a unique path with suffix
    generate_worktree_path "test-branch" result_path
    local second_path="$result_path"

    [ "$first_path" != "$second_path" ]
    [[ "$second_path" == *"_2" ]]
}

@test "generate_worktree_path: captures find command exit code" {
    mkdir -p ../worktrees
    local result_path

    # Create existing directory to trigger the find command
    generate_worktree_path "test-branch" result_path
    mkdir -p "$result_path"

    # This should trigger the find command to count existing directories
    generate_worktree_path "test-branch" result_path
    local exit_code=$?

    [ "$exit_code" -eq 0 ]
}

@test "generate_worktree_path: creates worktrees subdirectory if needed" {
    local result_path
    generate_worktree_path "test-branch" result_path

    # Should have created ../worktrees directory
    [ -d "../worktrees" ]
}

# Test check_branch_in_worktree function
@test "check_branch_in_worktree: captures worktree list exit code" {
    # This function should capture the exit code from git worktree list
    # Even if it fails, it should handle it gracefully
    run check_branch_in_worktree "test-branch" 1

    # Function should complete (exit 0) or exit if branch is found
    [ "$status" -eq 0 ] || [[ "$output" == *"already checked out"* ]]
}

# Test the nameref pattern used throughout
@test "nameref pattern: works with different variable names" {
    test_nameref_function() {
        local -n result_var=$1
        result_var="test_value"
    }

    local my_result
    test_nameref_function my_result
    [ "$my_result" = "test_value" ]
}

@test "nameref pattern: internal variable doesn't interfere" {
    test_nameref_with_local() {
        local -n result_var=$1
        local internal_path="internal_value"
        result_var="$internal_path"
    }

    local result
    test_nameref_with_local result
    [ "$result" = "internal_value" ]
}

# Test error handling in generate_worktree_path
@test "generate_worktree_path: returns error on sanitization failure" {
    # Override sanitize_branch_name to simulate failure
    sanitize_branch_name() {
        return 1
    }

    local result_path
    run generate_worktree_path "test-branch" result_path
    [ "$status" -eq 1 ]
}

@test "generate_worktree_path: validates absolute path conversion" {
    mkdir -p ../worktrees
    local result_path
    generate_worktree_path "test-branch" result_path

    # Path should be absolute
    [[ "$result_path" == /* ]]
}
