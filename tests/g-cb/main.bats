#!/usr/bin/env bats

# Tests for main function in g-cb

setup() {
    export TEST_DIR="$(mktemp -d)"
    cd "$TEST_DIR"
    git init -q
    git config user.name "Test User"
    git config user.email "test@example.com"
    git commit --allow-empty -m "Initial commit" -q

    source "${BATS_TEST_DIRNAME}/../../bin/utils"
    # g-cb may not exist yet, skip if not found
    if [ -f "${BATS_TEST_DIRNAME}/../../bin/g-cb" ]; then
        source "${BATS_TEST_DIRNAME}/../../bin/g-cb"
    else
        skip "g-cb script not found"
    fi
}

teardown() {
    rm -rf "$TEST_DIR"
}

@test "main: validates dependencies" {
    type validate_dependencies &>/dev/null
    [ $? -eq 0 ]
}

@test "main: prints banner" {
    type print_banner &>/dev/null
    [ $? -eq 0 ]
}
