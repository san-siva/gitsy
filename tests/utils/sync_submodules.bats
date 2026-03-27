#!/usr/bin/env bats

# Tests for sync_submodules function

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

@test "sync_submodules: skips when no .gitmodules file exists" {
    run sync_submodules 1
    [ "$status" -eq 0 ]
    [[ "$output" != *"Syncing submodules"* ]]
}

@test "sync_submodules: skips when .gitmodules has no submodule entries" {
    echo "# empty config" > .gitmodules

    run sync_submodules 1
    [ "$status" -eq 0 ]
    [[ "$output" != *"Syncing submodules"* ]]
}

@test "sync_submodules: runs with default step_number when not provided" {
    run sync_submodules
    [ "$status" -eq 0 ]
}

@test "sync_submodules: syncs submodules when .gitmodules exists with submodule entry" {
    # Create a non-bare repo with a commit to use as the submodule source
    local sub_source="$TEST_DIR/sub_source"
    git init -q "$sub_source"
    git -C "$sub_source" config user.name "Test User"
    git -C "$sub_source" config user.email "test@example.com"
    git -C "$sub_source" commit --allow-empty -q -m "Sub initial"

    # Add the submodule to the main repo using the local path as URL
    # -c protocol.file.allow=always is required in newer git versions
    git -c protocol.file.allow=always submodule add -q "$sub_source" external/sub
    git add .gitmodules external/sub
    git commit -q -m "Add submodule"

    # Remove the submodule working directory to simulate uninitialized state
    rm -rf external/sub

    run sync_submodules 1
    [ "$status" -eq 0 ]
    [[ "$output" == *"Syncing submodules"* ]]
    [[ "$output" == *"successfully"* ]]
    [ -d "external/sub" ]
}
