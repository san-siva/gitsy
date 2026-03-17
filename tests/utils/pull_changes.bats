#!/usr/bin/env bats

# Tests for pull_changes function

setup() {
    export TEST_DIR="$(mktemp -d)"
    cd "$TEST_DIR"

    source "${BATS_TEST_DIRNAME}/../../bin/utils"
}

teardown() {
    rm -rf "$TEST_DIR"
}

# Helper: create a bare remote and two clones (origin and local)
setup_repos() {
    local remote_dir="$TEST_DIR/remote.git"
    local origin_dir="$TEST_DIR/origin"
    local local_dir="$TEST_DIR/local"

    git init --bare -q "$remote_dir"

    git clone -q "$remote_dir" "$origin_dir"
    cd "$origin_dir"
    git config user.name "Test User"
    git config user.email "test@example.com"
    git commit --allow-empty -m "Initial commit" -q
    git push -q origin main 2>/dev/null || git push -q origin master 2>/dev/null

    git clone -q "$remote_dir" "$local_dir"
    cd "$local_dir"
    git config user.name "Test User"
    git config user.email "test@example.com"

    echo "$origin_dir $local_dir"
}

@test "pull_changes: function exists" {
    type pull_changes &>/dev/null
    [ $? -eq 0 ]
}

@test "pull_changes: exits with 1 when target branch is not set" {
    mkdir -p "$TEST_DIR/repo"
    cd "$TEST_DIR/repo"
    git init -q
    git config user.name "Test User"
    git config user.email "test@example.com"

    run pull_changes "" 1
    [ "$status" -eq 1 ]
}

@test "pull_changes: succeeds when there are no conflicts" {
    read -r origin_dir local_dir <<< "$(setup_repos)"

    local default_branch
    cd "$origin_dir"
    default_branch=$(git rev-parse --abbrev-ref HEAD)

    # Add a new commit on remote
    echo "remote change" > "$origin_dir/remote_file.txt"
    cd "$origin_dir"
    git add remote_file.txt
    git commit -q -m "Remote change"
    git push -q origin "$default_branch"

    cd "$local_dir"
    run pull_changes "$default_branch" 1
    [ "$status" -eq 0 ]
    [[ "$output" == *"successfully"* ]]
}

@test "pull_changes: exits with 1 and shows conflict error on merge conflict" {
    read -r origin_dir local_dir <<< "$(setup_repos)"

    local default_branch
    cd "$origin_dir"
    default_branch=$(git rev-parse --abbrev-ref HEAD)

    # Create a shared file in both repos with different content to trigger conflict
    echo "original" > "$origin_dir/shared.txt"
    cd "$origin_dir"
    git add shared.txt
    git commit -q -m "Add shared file"
    git push -q origin "$default_branch"

    # Pull the shared file into local
    cd "$local_dir"
    git pull -q origin "$default_branch"

    # Make conflicting changes on both sides
    echo "remote version" > "$origin_dir/shared.txt"
    cd "$origin_dir"
    git add shared.txt
    git commit -q -m "Remote edit"
    git push -q origin "$default_branch"

    echo "local version" > "$local_dir/shared.txt"
    cd "$local_dir"
    git add shared.txt
    git commit -q -m "Local edit"

    run pull_changes "$default_branch" 1
    [ "$status" -eq 1 ]
    [[ "$output" == *"conflict"* ]] || [[ "$output" == *"Conflict"* ]]
}

@test "pull_changes: exits with 1 and shows generic error when pull fails for other reasons" {
    mkdir -p "$TEST_DIR/repo"
    cd "$TEST_DIR/repo"
    git init -q
    git config user.name "Test User"
    git config user.email "test@example.com"

    # No remote configured — pull must fail
    run pull_changes "main" 1
    [ "$status" -eq 1 ]
    [[ "$output" == *"Failed"* ]] || [[ "$output" == *"fail"* ]]
}
