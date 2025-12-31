#!/usr/bin/env bats

# Tests for sanitize_branch_name function

setup() {
    export TEST_DIR="$(mktemp -d)"
    cd "$TEST_DIR"

    source "${BATS_TEST_DIRNAME}/../../bin/utils"
}

teardown() {
    rm -rf "$TEST_DIR"
}

@test "sanitize_branch_name: converts forward slashes to underscores" {
    local branch_result
    sanitize_branch_name "feature/test-branch" branch_result

    [ "$branch_result" = "feature_test_branch" ]
}

@test "sanitize_branch_name: converts hyphens to underscores" {
    local branch_result
    sanitize_branch_name "test-branch-name" branch_result

    [ "$branch_result" = "test_branch_name" ]
}

@test "sanitize_branch_name: converts to lowercase" {
    local branch_result
    sanitize_branch_name "FEATURE-BRANCH" branch_result

    [ "$branch_result" = "feature_branch" ]
}

@test "sanitize_branch_name: handles mixed case and special characters" {
    local branch_result
    sanitize_branch_name "Feature/TEST-Branch" branch_result

    [ "$branch_result" = "feature_test_branch" ]
}

@test "sanitize_branch_name: truncates long branch names to default 30 chars" {
    local branch_result
    sanitize_branch_name "very-long-branch-name-that-exceeds-thirty-characters" branch_result 30

    [ "${#branch_result}" -eq 32 ]  # 30 + 2 for ".."
    [[ "$branch_result" == *".." ]]
}

@test "sanitize_branch_name: truncates with custom max length" {
    local branch_result
    sanitize_branch_name "long-branch-name" branch_result 10

    [ "${#branch_result}" -le 12 ]  # 10 + 2 for possible ".."
}

@test "sanitize_branch_name: handles real-world JIRA branch names" {
    local branch_result
    sanitize_branch_name "EXT-5994__template_changes_for_element_selectors__test_fix_dump" branch_result

    [[ "$branch_result" == "ext_5994__template_changes_for"* ]]
    [ "${#branch_result}" -le 32 ]
}

@test "sanitize_branch_name: handles underscores correctly" {
    local branch_result
    sanitize_branch_name "test_branch_name" branch_result

    [ "$branch_result" = "test_branch_name" ]
}

@test "sanitize_branch_name: handles dots" {
    local branch_result
    sanitize_branch_name "release.1.0.0" branch_result

    [ "$branch_result" = "release_1_0_0" ]
}

@test "sanitize_branch_name: handles exit code correctly" {
    local branch_result
    sanitize_branch_name "test/branch" branch_result
    local exit_code=$?

    [ "$exit_code" -eq 0 ]
    [ -n "$branch_result" ]
}

@test "sanitize_branch_name: captures sed pipeline exit code" {
    # Test the pattern used in the code
    local branch_name="TEST-BRANCH"
    local sanitized
    sanitized=$(echo "$branch_name" | sed -E 's/[^[:alnum:]]/_/g' | tr '[:upper:]' '[:lower:]')
    local sanitize_exit=$?

    [ "$sanitize_exit" -eq 0 ]
    [ "$sanitized" = "test_branch" ]
}

@test "sanitize_branch_name: nameref works with different variable names" {
    local result1
    sanitize_branch_name "test-branch" result1
    [ "$result1" = "test_branch" ]

    local result2
    sanitize_branch_name "test-branch" result2
    [ "$result2" = "test_branch" ]
}

@test "sanitize_branch_name: handles empty input gracefully" {
    local branch_result
    sanitize_branch_name "" branch_result

    # Should still complete without error
    [ "$?" -eq 0 ]
}

@test "sanitize_branch_name: handles numbers correctly" {
    local branch_result
    sanitize_branch_name "feature/123-test" branch_result

    [ "$branch_result" = "feature_123_test" ]
}
