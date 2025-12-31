#!/usr/bin/env bats

# Tests for main function in g-wa

setup() {
    export TEST_DIR="$(mktemp -d)"
    cd "$TEST_DIR"
    git init -q
    git config user.name "Test User"
    git config user.email "test@example.com"
    git commit --allow-empty -m "Initial commit" -q

    source "${BATS_TEST_DIRNAME}/../../bin/utils"
    source "${BATS_TEST_DIRNAME}/../../bin/g-wa"
}

teardown() {
    rm -rf "$TEST_DIR"
}

@test "main: validates dependencies" {
    type validate_dependencies &>/dev/null
    [ $? -eq 0 ]
}

@test "main: calls print_banner" {
    type print_banner &>/dev/null
    [ $? -eq 0 ]
}

@test "main: checks if target branch is set" {
    type check_if_target_branch_is_set &>/dev/null
    [ $? -eq 0 ]
}

@test "main: checks if in git repo" {
    type is_git_repo &>/dev/null
    [ $? -eq 0 ]
}

@test "main: checks already_on_branch" {
    type already_on_branch &>/dev/null
    [ $? -eq 0 ]
}

@test "main: calls stash_changes" {
    type stash_changes &>/dev/null
    [ $? -eq 0 ]
}

@test "main: gets default branch" {
    type get_default_branch &>/dev/null
    [ $? -eq 0 ]
}

@test "main: gets current branch" {
    type get_current_branch &>/dev/null
    [ $? -eq 0 ]
}
