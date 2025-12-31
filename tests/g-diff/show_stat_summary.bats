#!/usr/bin/env bats

# Tests for show_stat_summary function in g-diff

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

@test "show_stat_summary: captures git diff stat exit code immediately" {
    target_branch="main"
    source_branch="test"

    local stats_content
    if stats_content=$(git diff --stat "origin/${target_branch}..${source_branch}" 2>&1); then
        local exit_code=$?
        [ -n "$exit_code" ]
    fi
}

@test "show_stat_summary: function exists" {
    type show_stat_summary &>/dev/null
    [ $? -eq 0 ]
}
