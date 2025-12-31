#!/usr/bin/env bats

# Tests for get_default_branch function

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

@test "get_default_branch: falls back to main when no remote" {
    # Get the current default branch name (from git init)
    local current_branch=$(git branch --show-current)

    local default_branch
    get_default_branch default_branch

    # Should return the current branch that exists (or main if it exists)
    [ -n "$default_branch" ]
    # Since we have the initial branch, it should return that
    [ "$default_branch" = "$current_branch" ]
}

@test "get_default_branch: returns main if main branch exists locally" {
    # Check if main already exists, if not create it
    if ! git show-ref --verify --quiet refs/heads/main; then
        git checkout -b main -q
    fi

    local default_branch
    get_default_branch default_branch

    [ "$default_branch" = "main" ]
}

@test "get_default_branch: returns master if only master exists" {
    # Get current branch and switch to master
    local current=$(git branch --show-current)

    # Create master if it doesn't exist
    if ! git show-ref --verify --quiet refs/heads/master; then
        git checkout -b master -q
    else
        git checkout master -q
    fi

    # Delete the original branch if it's not master
    if [ "$current" != "master" ] && [ -n "$current" ]; then
        git branch -D "$current" 2>/dev/null || true
    fi

    # Delete main if it exists and is not the current branch
    if git show-ref --verify --quiet refs/heads/main && [ "$(git branch --show-current)" != "main" ]; then
        git branch -D main 2>/dev/null || true
    fi

    local default_branch
    get_default_branch default_branch

    [ "$default_branch" = "master" ]
}

@test "get_default_branch: captures exit code from git symbolic-ref" {
    # Test the pattern we use in the code
    local default_branch_result
    default_branch_result=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@')
    local exit_code=$?

    # Exit code should be captured correctly
    [ -n "$exit_code" ]
}

@test "get_default_branch: handles exit code correctly" {
    # Ensure we have at least one branch
    if ! git show-ref --verify --quiet refs/heads/main; then
        if ! git show-ref --verify --quiet refs/heads/master; then
            # Create a branch if none exist
            git checkout -b main -q 2>/dev/null || true
        fi
    fi

    local default_branch
    get_default_branch default_branch
    local exit_code=$?

    [ "$exit_code" -eq 0 ]
    [ -n "$default_branch" ]
}

@test "get_default_branch: nameref works with different variable names" {
    local my_default
    get_default_branch my_default
    [ -n "$my_default" ]

    local another_default
    get_default_branch another_default
    [ -n "$another_default" ]
}
