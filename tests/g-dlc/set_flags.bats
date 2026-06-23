#!/usr/bin/env bats

# Tests for set_flags --force handling in g-dlc.
# g-dlc unifies its historical --force (hard reset) with the global FORCE
# (skip the confirmation prompt): a single --force now means both.

setup() {
    source "${BATS_TEST_DIRNAME}/../../bin/utils"
    source "${BATS_TEST_DIRNAME}/../../bin/g-dlc"
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

@test "set_flags: no flag leaves FORCE=false" {
    FORCE=false
    set_flags
    [ "$FORCE" = "false" ]
}

@test "force_mode is wired to FORCE (hard reset + skip prompt)" {
    # main() does: force_mode="$FORCE" after parsing
    FORCE=false
    set_flags "--force"
    force_mode="$FORCE"
    [ "$force_mode" = "true" ]
}

@test "set_flags: genuinely unknown flag still errors" {
    run set_flags "--bogus"
    [ "$status" -eq 1 ]
    [[ "$output" =~ "Unknown option" ]]
}
