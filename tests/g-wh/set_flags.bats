#!/usr/bin/env bats

# Tests for set_flags in g-wh

setup() {
    source "${BATS_TEST_DIRNAME}/../../bin/utils"
    source "${BATS_TEST_DIRNAME}/../../bin/g-wh"
}

@test "set_flags: -w sets worktree_name" {
    worktree_name=
    set_flags "-w" "my_worktree"
    [ "$worktree_name" = "my_worktree" ]
}

@test "set_flags: --worktree-name=VALUE sets worktree_name" {
    worktree_name=
    set_flags "--worktree-name=my_worktree"
    [ "$worktree_name" = "my_worktree" ]
}

@test "set_flags: -t sets target_branch" {
    target_branch=
    set_flags "-t" "my-branch"
    [ "$target_branch" = "my-branch" ]
}

@test "set_flags: --target-branch=VALUE sets target_branch" {
    target_branch=
    set_flags "--target-branch=my-branch"
    [ "$target_branch" = "my-branch" ]
}

@test "set_flags: -w with no value errors" {
    run set_flags "-w"
    [ "$status" -eq 1 ]
}

@test "set_flags: -t with no value errors" {
    run set_flags "-t"
    [ "$status" -eq 1 ]
}

@test "set_flags: -a sets heal_all=true" {
    heal_all=false
    set_flags "-a"
    [ "$heal_all" = "true" ]
}

@test "set_flags: --all sets heal_all=true" {
    heal_all=false
    set_flags "--all"
    [ "$heal_all" = "true" ]
}

@test "set_flags: --dry-run sets dry_run=true" {
    dry_run=false
    set_flags "--dry-run"
    [ "$dry_run" = "true" ]
}

@test "set_flags: -f sets FORCE=true via set_global_flag" {
    FORCE=false
    set_flags "-f"
    [ "$FORCE" = "true" ]
}

@test "set_flags: --force sets FORCE=true via set_global_flag" {
    FORCE=false
    set_flags "--force"
    [ "$FORCE" = "true" ]
}

@test "set_flags: combines multiple flags" {
    worktree_name=
    dry_run=false
    FORCE=false
    set_flags "-w" "feature" "--dry-run" "--force"
    [ "$worktree_name" = "feature" ]
    [ "$dry_run" = "true" ]
    [ "$FORCE" = "true" ]
}

@test "set_flags: genuinely unknown flag errors" {
    run set_flags "--bogus"
    [ "$status" -eq 1 ]
}
