#!/usr/bin/env bats

# Tests for -o/--output-file option in g-diff

setup() {
    export REMOTE_DIR="$(mktemp -d)"
    export TEST_DIR="$(mktemp -d)"

    # Create bare remote repo to act as origin
    git init -q --bare "$REMOTE_DIR"

    cd "$TEST_DIR"
    git init -q
    git config user.name "Test User"
    git config user.email "test@example.com"
    git remote add origin "$REMOTE_DIR"

    # Seed main branch and push
    echo "initial" > file.txt
    git add file.txt
    git commit -m "Initial commit" -q
    git push origin HEAD:main -q

    # Create feature branch with a new file and push
    git checkout -b feature -q
    echo "feature content" > feature.txt
    git add feature.txt
    git commit -m "Add feature" -q
    git push origin feature -q

    # Fetch so origin/* refs are available
    git fetch origin -q

    git checkout main -q

    source "${BATS_TEST_DIRNAME}/../../bin/utils"
    source "${BATS_TEST_DIRNAME}/../../bin/g-diff"

    # Prevent pbcopy from being called in tests
    copy_to_clipboard() { :; }

    export OUTPUT_FILE="$TEST_DIR/output.txt"
}

teardown() {
    rm -rf "$TEST_DIR" "$REMOTE_DIR"
}

# ---------------------------------------------------------------------------
# set_flags: parsing
# ---------------------------------------------------------------------------

@test "set_flags: -o FILE sets output_file" {
    set_flags -o "$OUTPUT_FILE"
    [ "$output_file" = "$OUTPUT_FILE" ]
}

@test "set_flags: --output-file FILE sets output_file" {
    set_flags --output-file "$OUTPUT_FILE"
    [ "$output_file" = "$OUTPUT_FILE" ]
}

@test "set_flags: --output-file=FILE sets output_file" {
    set_flags "--output-file=$OUTPUT_FILE"
    [ "$output_file" = "$OUTPUT_FILE" ]
}

@test "set_flags: -o without file exits with error" {
    run bash -c "
        source '${BATS_TEST_DIRNAME}/../../bin/utils'
        source '${BATS_TEST_DIRNAME}/../../bin/g-diff'
        set_flags -o
    "
    [ "$status" -eq 1 ]
}

@test "set_flags: --output-file without file exits with error" {
    run bash -c "
        source '${BATS_TEST_DIRNAME}/../../bin/utils'
        source '${BATS_TEST_DIRNAME}/../../bin/g-diff'
        set_flags --output-file
    "
    [ "$status" -eq 1 ]
}

# ---------------------------------------------------------------------------
# show_files_only: output_file behaviour
# ---------------------------------------------------------------------------

@test "show_files_only: writes filenames to file when output_file is set" {
    target_branch="main"
    source_branch="feature"
    output_file="$OUTPUT_FILE"

    show_files_only

    [ -f "$OUTPUT_FILE" ]
    grep -q "feature.txt" "$OUTPUT_FILE"
}

@test "show_files_only: file contains no ANSI color codes" {
    target_branch="main"
    source_branch="feature"
    output_file="$OUTPUT_FILE"

    show_files_only

    run grep -P '\x1b\[' "$OUTPUT_FILE"
    [ "$status" -ne 0 ]
}

@test "show_files_only: does not create file when output_file is empty" {
    target_branch="main"
    source_branch="feature"
    output_file=""

    show_files_only

    [ ! -f "$OUTPUT_FILE" ]
}

# ---------------------------------------------------------------------------
# show_stat_summary: output_file behaviour
# ---------------------------------------------------------------------------

@test "show_stat_summary: writes stats to file when output_file is set" {
    target_branch="main"
    source_branch="feature"
    output_file="$OUTPUT_FILE"

    show_stat_summary

    [ -f "$OUTPUT_FILE" ]
    [ -s "$OUTPUT_FILE" ]
}

@test "show_stat_summary: file contains no ANSI color codes" {
    target_branch="main"
    source_branch="feature"
    output_file="$OUTPUT_FILE"

    show_stat_summary

    run grep -P '\x1b\[' "$OUTPUT_FILE"
    [ "$status" -ne 0 ]
}

@test "show_stat_summary: does not create file when output_file is empty" {
    target_branch="main"
    source_branch="feature"
    output_file=""

    show_stat_summary

    [ ! -f "$OUTPUT_FILE" ]
}

# ---------------------------------------------------------------------------
# show_full_diff: output_file behaviour
# ---------------------------------------------------------------------------

@test "show_full_diff: writes diff to file when output_file is set" {
    target_branch="main"
    source_branch="feature"
    output_file="$OUTPUT_FILE"

    show_full_diff

    [ -f "$OUTPUT_FILE" ]
    grep -q "feature.txt" "$OUTPUT_FILE"
}

@test "show_full_diff: file contains no ANSI color codes" {
    target_branch="main"
    source_branch="feature"
    output_file="$OUTPUT_FILE"

    show_full_diff

    run grep -P '\x1b\[' "$OUTPUT_FILE"
    [ "$status" -ne 0 ]
}

@test "show_full_diff: does not create file when output_file is empty" {
    target_branch="main"
    source_branch="feature"
    output_file=""

    show_full_diff

    [ ! -f "$OUTPUT_FILE" ]
}
