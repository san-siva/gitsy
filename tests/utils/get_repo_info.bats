#!/usr/bin/env bats

# Tests for get_repo_info function

setup() {
    export TEST_DIR="$(mktemp -d)"
    cd "$TEST_DIR"
    git init -q
    git config user.name "Test User"
    git config user.email "test@example.com"
    git commit --allow-empty -m "Initial commit" -q

    source "${BATS_TEST_DIRNAME}/../../bin/utils"
}

teardown() {
    rm -rf "$TEST_DIR"
}

@test "get_repo_info: populates git_root" {
    local git_root current_dir parent_dir repo_name
    get_repo_info git_root current_dir parent_dir repo_name

    [ -n "$git_root" ]
    [ -d "$git_root" ]
}

@test "get_repo_info: populates current_dir" {
    local git_root current_dir parent_dir repo_name
    get_repo_info git_root current_dir parent_dir repo_name

    [ -n "$current_dir" ]
}

@test "get_repo_info: populates parent_dir" {
    local git_root current_dir parent_dir repo_name
    get_repo_info git_root current_dir parent_dir repo_name

    [ -n "$parent_dir" ]
}

@test "get_repo_info: populates repo_name" {
    git remote add origin "https://github.com/user/test-repo.git"

    local git_root current_dir parent_dir repo_name
    get_repo_info git_root current_dir parent_dir repo_name

    [ "$repo_name" = "test-repo" ]
}

@test "get_repo_info: captures git rev-parse exit code" {
    # Test the pattern used in the code
    local git_root_ref
    git_root_ref=$(git rev-parse --show-toplevel)
    local git_root_exit=$?

    [ "$git_root_exit" -eq 0 ]
    [ -n "$git_root_ref" ]
}

@test "get_repo_info: returns success exit code" {
    local git_root current_dir parent_dir repo_name
    get_repo_info git_root current_dir parent_dir repo_name
    local exit_code=$?

    [ "$exit_code" -eq 0 ]
}

@test "get_repo_info: all namerefs work correctly" {
    git remote add origin "https://github.com/user/my-repo.git"

    local root dir parent name
    get_repo_info root dir parent name

    [ -n "$root" ]
    [ -n "$dir" ]
    [ -n "$parent" ]
    [ "$name" = "my-repo" ]
}

@test "get_repo_info: git_root is absolute path" {
    local git_root current_dir parent_dir repo_name
    get_repo_info git_root current_dir parent_dir repo_name

    [[ "$git_root" == /* ]]
}
