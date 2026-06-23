#!/usr/bin/env bats

# Tests for the --force bypass: prompt_user and set_global_flag

setup() {
    source "${BATS_TEST_DIRNAME}/../../bin/utils"
}

@test "set_global_flag: --force sets FORCE=true and returns 0" {
    FORCE=false
    run set_global_flag "--force"
    [ "$status" -eq 0 ]

    # Run again outside `run` so FORCE is set in this shell, not a subshell
    FORCE=false
    set_global_flag "--force"
    [ "$FORCE" = "true" ]
}

@test "set_global_flag: -f sets FORCE=true and returns 0" {
    FORCE=false
    set_global_flag "-f"
    [ "$FORCE" = "true" ]
}

@test "set_global_flag: unknown flag returns 1 and leaves FORCE untouched" {
    FORCE=false
    run set_global_flag "--bogus"
    [ "$status" -eq 1 ]
    [ "$FORCE" = "false" ]
}

@test "prompt_user: FORCE=true auto-answers yes for a default-no prompt" {
    FORCE=true
    result=$(prompt_user "false" "Discard everything?" 1)
    [ "$result" = "y" ]
}

@test "prompt_user: FORCE=true auto-answers yes for a default-yes prompt" {
    FORCE=true
    result=$(prompt_user "true" "Create new branch?" 1)
    [ "$result" = "y" ]
}

@test "prompt_user: FORCE=true ignores stdin (does not read)" {
    FORCE=true
    # Pipe "n" — without the bypass this would return "n"
    result=$(echo "n" | prompt_user "false" "Discard everything?" 1)
    [ "$result" = "y" ]
}

@test "prompt_user: without FORCE, reads the answer from stdin" {
    FORCE=false
    result=$(echo "n" | prompt_user "false" "Discard everything?" 1)
    [ "$result" = "n" ]

    result=$(echo "y" | prompt_user "false" "Discard everything?" 1)
    [ "$result" = "y" ]
}

@test "prompt_user: without FORCE, empty input uses the default" {
    FORCE=false
    result=$(echo "" | prompt_user "true" "Create new branch?" 1)
    [ "$result" = "y" ]

    result=$(echo "" | prompt_user "false" "Discard everything?" 1)
    [ "$result" = "n" ]
}
