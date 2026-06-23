#!/usr/bin/env bats

# Tests for set_flags --force handling in g-wr

setup() {
    source "${BATS_TEST_DIRNAME}/../../bin/utils"
    source "${BATS_TEST_DIRNAME}/../../bin/g-wr"
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
    set_flags "-t" "my-branch" "--force"
    [ "$FORCE" = "true" ]
    [ "$target_branch" = "my-branch" ]
}

@test "set_flags: genuinely unknown flag still errors" {
    run set_flags "--bogus"
    [ "$status" -eq 1 ]
}
