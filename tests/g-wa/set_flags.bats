#!/usr/bin/env bats

# Tests for set_flags --force handling in g-wa

setup() {
    source "${BATS_TEST_DIRNAME}/../../bin/utils"
    source "${BATS_TEST_DIRNAME}/../../bin/g-wa"
}

@test "set_flags: --force sets FORCE=true" {
    FORCE=false
    set_flags "--force"
    [ "$FORCE" = "true" ]
}

@test "set_flags: -f sets FORCE=true" {
    FORCE=false
    set_flags "-f"
    [ "$FORCE" = "true" ]
}

@test "set_flags: --force alongside other flags still parses them" {
    FORCE=false
    set_flags "--target-branch=test-branch" "--worktree-name=my-name" "--force"
    [ "$FORCE" = "true" ]
    [ "$target_branch" = "test-branch" ]
    [ "$custom_worktree_name" = "my-name" ]
}
