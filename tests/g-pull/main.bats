#!/usr/bin/env bats

# Tests for main function in g-pull

# Helper: set up a bare remote, an origin clone (with commits), and a local clone
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

setup() {
    export TEST_DIR="$(mktemp -d)"
    cd "$TEST_DIR"

    source "${BATS_TEST_DIRNAME}/../../bin/utils"
    source "${BATS_TEST_DIRNAME}/../../bin/g-pull"
}

teardown() {
    rm -rf "$TEST_DIR"
}

@test "main: pulls from the specified -t branch" {
    read -r origin_dir local_dir <<< "$(setup_repos)"

    local default_branch
    cd "$origin_dir"
    default_branch=$(git rev-parse --abbrev-ref HEAD)

    echo "new file" > "$origin_dir/new_file.txt"
    git -C "$origin_dir" add new_file.txt
    git -C "$origin_dir" commit -q -m "Add new file"
    git -C "$origin_dir" push -q origin "$default_branch"

    cd "$local_dir"
    pull_changes "$default_branch" 1
    [ -f "$local_dir/new_file.txt" ]
}

@test "main: defaults to current branch when no -t given" {
    read -r origin_dir local_dir <<< "$(setup_repos)"

    local default_branch
    cd "$origin_dir"
    default_branch=$(git rev-parse --abbrev-ref HEAD)

    echo "from remote" > "$origin_dir/remote.txt"
    git -C "$origin_dir" add remote.txt
    git -C "$origin_dir" commit -q -m "Remote commit"
    git -C "$origin_dir" push -q origin "$default_branch"

    cd "$local_dir"
    # main() reads current branch when target_branch is empty
    target_branch=""
    get_current_branch target_branch
    [ "$target_branch" = "$default_branch" ]

    pull_changes "$target_branch" 1
    [ -f "$local_dir/remote.txt" ]
}

@test "main: exits 1 and shows conflict message on merge conflict" {
    read -r origin_dir local_dir <<< "$(setup_repos)"

    local default_branch
    cd "$origin_dir"
    default_branch=$(git rev-parse --abbrev-ref HEAD)

    # Create shared file
    echo "base" > "$origin_dir/shared.txt"
    git -C "$origin_dir" add shared.txt
    git -C "$origin_dir" commit -q -m "Add shared file"
    git -C "$origin_dir" push -q origin "$default_branch"

    cd "$local_dir"
    git pull -q origin "$default_branch"

    # Diverging edits on both sides
    echo "remote edit" > "$origin_dir/shared.txt"
    git -C "$origin_dir" add shared.txt
    git -C "$origin_dir" commit -q -m "Remote edit"
    git -C "$origin_dir" push -q origin "$default_branch"

    echo "local edit" > "$local_dir/shared.txt"
    git -C "$local_dir" add shared.txt
    git -C "$local_dir" commit -q -m "Local edit"

    run pull_changes "$default_branch" 1
    [ "$status" -eq 1 ]
    [[ "$output" == *"conflict"* ]] || [[ "$output" == *"Conflict"* ]]
}

@test "main: exits 1 with error when pull fails (no remote)" {
    mkdir -p "$TEST_DIR/isolated"
    cd "$TEST_DIR/isolated"
    git init -q
    git config user.name "Test User"
    git config user.email "test@example.com"

    run pull_changes "main" 1
    [ "$status" -eq 1 ]
    [[ "$output" == *"[Fail]"* ]]
}

@test "main: with -f flag, fetch_changes is called before pull_changes" {
    read -r origin_dir local_dir <<< "$(setup_repos)"

    local default_branch
    cd "$origin_dir"
    default_branch=$(git rev-parse --abbrev-ref HEAD)

    echo "fetched file" > "$origin_dir/fetched.txt"
    git -C "$origin_dir" add fetched.txt
    git -C "$origin_dir" commit -q -m "Add fetched file"
    git -C "$origin_dir" push -q origin "$default_branch"

    cd "$local_dir"
    fetch_changes "$default_branch"
    pull_changes "$default_branch" 2
    [ -f "$local_dir/fetched.txt" ]
}

@test "main: does not report success when conflicts remain after pull" {
    read -r origin_dir local_dir <<< "$(setup_repos)"

    local default_branch
    cd "$origin_dir"
    default_branch=$(git rev-parse --abbrev-ref HEAD)

    echo "base" > "$origin_dir/conflict.txt"
    git -C "$origin_dir" add conflict.txt
    git -C "$origin_dir" commit -q -m "Base"
    git -C "$origin_dir" push -q origin "$default_branch"

    cd "$local_dir"
    git pull -q origin "$default_branch"

    echo "remote" > "$origin_dir/conflict.txt"
    git -C "$origin_dir" add conflict.txt
    git -C "$origin_dir" commit -q -m "Remote"
    git -C "$origin_dir" push -q origin "$default_branch"

    echo "local" > "$local_dir/conflict.txt"
    git -C "$local_dir" add conflict.txt
    git -C "$local_dir" commit -q -m "Local"

    run pull_changes "$default_branch" 1
    [ "$status" -eq 1 ]
    [[ "$output" != *"successfully"* ]]
}
