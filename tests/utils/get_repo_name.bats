#!/usr/bin/env bats

# Tests for get_repo_name function

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

@test "get_repo_name: extracts name from HTTPS URL" {
    git remote add origin "https://github.com/user/test-repo.git"

    local repo_name
    get_repo_name repo_name

    [ "$repo_name" = "test-repo" ]
}

@test "get_repo_name: extracts name from HTTPS URL without .git" {
    git remote add origin "https://github.com/user/test-repo"

    local repo_name
    get_repo_name repo_name

    [ "$repo_name" = "test-repo" ]
}

@test "get_repo_name: extracts name from SSH URL" {
    git remote add origin "git@github.com:user/test-repo.git"

    local repo_name
    get_repo_name repo_name

    [ "$repo_name" = "test-repo" ]
}

@test "get_repo_name: extracts name from SSH URL without .git" {
    git remote add origin "git@github.com:user/test-repo"

    local repo_name
    get_repo_name repo_name

    [ "$repo_name" = "test-repo" ]
}

@test "get_repo_name: handles GitLab URLs" {
    git remote add origin "https://gitlab.com/user/test-repo.git"

    local repo_name
    get_repo_name repo_name

    [ "$repo_name" = "test-repo" ]
}

@test "get_repo_name: handles enterprise GitHub URLs" {
    git remote add origin "https://github.company.com/user/test-repo.git"

    local repo_name
    get_repo_name repo_name

    [ "$repo_name" = "test-repo" ]
}

@test "get_repo_name: handles repository names with hyphens" {
    git remote add origin "https://github.com/user/my-test-repo.git"

    local repo_name
    get_repo_name repo_name

    [ "$repo_name" = "my-test-repo" ]
}

@test "get_repo_name: handles repository names with underscores" {
    git remote add origin "https://github.com/user/my_test_repo.git"

    local repo_name
    get_repo_name repo_name

    [ "$repo_name" = "my_test_repo" ]
}

@test "get_repo_name: handles repository names with dots" {
    git remote add origin "https://github.com/user/test.repo.git"

    local repo_name
    get_repo_name repo_name

    [ "$repo_name" = "test.repo" ]
}

@test "get_repo_name: captures exit code from sed pipeline" {
    git remote add origin "https://github.com/user/test-repo.git"

    local repo_name
    get_repo_name repo_name
    local exit_code=$?

    [ "$exit_code" -eq 0 ]
    [ -n "$repo_name" ]
}

@test "get_repo_name: sed extraction captures exit code immediately" {
    # Test the pattern used in the code
    local remote_url="https://github.com/user/test-repo.git"
    local result
    result=$(echo "$remote_url" | sed -E 's#.*/([^/]+)(\.git)?$#\1#' | sed 's/\.git$//')
    local extract_exit=$?

    [ "$extract_exit" -eq 0 ]
    [ "$result" = "test-repo" ]
}

@test "get_repo_name: nameref works correctly" {
    git remote add origin "https://github.com/user/test-repo.git"

    local my_repo_name
    get_repo_name my_repo_name

    [ "$my_repo_name" = "test-repo" ]
}
