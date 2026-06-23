#!/usr/bin/env bats

# Tests for set_flags --force handling in g-db

setup() {
    source "${BATS_TEST_DIRNAME}/../../bin/utils"
    source "${BATS_TEST_DIRNAME}/../../bin/g-db"
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

@test "set_flags: --force alongside --target-branch still parses both" {
    FORCE=false
    set_flags "-t" "old-branch" "--force"
    [ "$FORCE" = "true" ]
    [ "$target_branch" = "old-branch" ]
}

@test "set_flags: genuinely unknown flag still errors" {
    run set_flags "--bogus"
    [ "$status" -eq 1 ]
    [[ "$output" =~ "Unknown option" ]]
}
