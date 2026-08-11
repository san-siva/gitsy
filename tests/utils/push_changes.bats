#!/usr/bin/env bats

# Tests for push_changes function

setup() {
    export TEST_DIR="$(mktemp -d)"
    cd "$TEST_DIR"

    source "${BATS_TEST_DIRNAME}/../../bin/utils"
}

teardown() {
    rm -rf "$TEST_DIR"
}

# Helper: create a bare remote and a clone with a commit ready to push
setup_repos() {
    local remote_dir="$TEST_DIR/remote.git"
    local local_dir="$TEST_DIR/local"

    git init --bare -q "$remote_dir"

    git clone -q "$remote_dir" "$local_dir"
    cd "$local_dir"
    git config user.name "Test User"
    git config user.email "test@example.com"
    git commit --allow-empty -m "Initial commit" -q

    echo "$local_dir"
}

@test "push_changes: function exists" {
    type push_changes &>/dev/null
    [ $? -eq 0 ]
}

@test "push_changes: exits with 1 when target branch is not set" {
    mkdir -p "$TEST_DIR/repo"
    cd "$TEST_DIR/repo"
    git init -q
    git config user.name "Test User"
    git config user.email "test@example.com"

    run push_changes "" false 1
    [ "$status" -eq 1 ]
}

@test "push_changes: succeeds and reports success when push works" {
    local_dir="$(setup_repos)"
    cd "$local_dir"
    local default_branch
    default_branch=$(git rev-parse --abbrev-ref HEAD)

    run push_changes "$default_branch" false 1
    [ "$status" -eq 0 ]
    [[ "$output" == *"successfully"* ]]
}

@test "push_changes: force push succeeds and reports success" {
    local_dir="$(setup_repos)"
    cd "$local_dir"
    local default_branch
    default_branch=$(git rev-parse --abbrev-ref HEAD)

    run push_changes "$default_branch" true 1
    [ "$status" -eq 0 ]
    [[ "$output" == *"successfully"* ]]
}

@test "push_changes: exits with 1 and shows failure message when git push fails" {
    mkdir -p "$TEST_DIR/repo"
    cd "$TEST_DIR/repo"
    git init -q
    git config user.name "Test User"
    git config user.email "test@example.com"
    git commit --allow-empty -m "Initial commit" -q
    git remote add origin "$TEST_DIR/does-not-exist.git"

    run push_changes "main" false 1
    [ "$status" -eq 1 ]
    [[ "$output" == *"Failed"* ]] || [[ "$output" == *"failed"* ]]
}

@test "push_changes: exits with 1 when local branch has diverged from remote and --force not used" {
    local_dir="$(setup_repos)"
    cd "$local_dir"
    local default_branch
    default_branch=$(git rev-parse --abbrev-ref HEAD)

    # Publish the initial commit
    git push -q origin "$default_branch"

    # Simulate someone else pushing a commit that local doesn't have
    local other_dir="$TEST_DIR/other"
    git clone -q "$TEST_DIR/remote.git" "$other_dir"
    cd "$other_dir"
    git config user.name "Other User"
    git config user.email "other@example.com"
    git commit --allow-empty -m "Remote-only commit" -q
    git push -q origin "$default_branch"

    # Local diverges with its own unpushed commit
    cd "$local_dir"
    git commit --allow-empty -m "Local-only commit" -q

    run push_changes "$default_branch" false 1
    [ "$status" -eq 1 ]
    [[ "$output" == *"diverged"* ]] || [[ "$output" == *"behind"* ]]
}
