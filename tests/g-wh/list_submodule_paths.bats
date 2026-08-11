#!/usr/bin/env bats

# Tests for list_submodule_paths in g-wh

setup() {
    export TEST_DIR="$(mktemp -d)"
    cd "$TEST_DIR"
    git init -q
    git config user.name "Test User"
    git config user.email "test@example.com"

    source "${BATS_TEST_DIRNAME}/../../bin/utils"
    source "${BATS_TEST_DIRNAME}/../../bin/g-wh"
}

teardown() {
    rm -rf "$TEST_DIR"
}

@test "list_submodule_paths: no .gitmodules yields empty list" {
    local -a paths
    list_submodule_paths "$TEST_DIR" paths
    [ ${#paths[@]} -eq 0 ]
}

@test "list_submodule_paths: reads a single submodule path" {
    cat >"$TEST_DIR/.gitmodules" <<'EOF'
[submodule "external/foo"]
	path = external/foo
	url = ../foo.git
EOF

    local -a paths
    list_submodule_paths "$TEST_DIR" paths
    [ ${#paths[@]} -eq 1 ]
    [ "${paths[0]}" = "external/foo" ]
}

@test "list_submodule_paths: reads multiple submodule paths" {
    cat >"$TEST_DIR/.gitmodules" <<'EOF'
[submodule "external/foo"]
	path = external/foo
	url = ../foo.git
[submodule "external/bar"]
	path = external/bar
	url = ../bar.git
EOF

    local -a paths
    list_submodule_paths "$TEST_DIR" paths
    [ ${#paths[@]} -eq 2 ]
    [[ " ${paths[*]} " == *" external/foo "* ]]
    [[ " ${paths[*]} " == *" external/bar "* ]]
}
