# Gitsy Command Tests

Complete test suite for all gitsy commands. Each command has its own directory with separate test files for each function.

## Test Structure

```
tests/
├── g-db/                  # Delete branch
│   ├── delete_local_branch.bats
│   ├── prompt_user_confirmation.bats
│   ├── prompt_remote_deletion.bats
│   ├── main.bats
│   └── README.md
├── g-wa/                  # Worktree add
│   ├── generate_worktree_path.bats    ⭐ 11 tests (bug fix verified)
│   ├── check_branch_in_worktree.bats
│   ├── try_fetching_branch.bats
│   ├── checkout_or_create_branch.bats
│   ├── main.bats
│   └── README.md
├── g-wr/                  # Worktree remove
│   ├── cd_to_worktrees_dir.bats
│   ├── find_worktree_by_name.bats
│   ├── find_worktree_by_branch.bats
│   ├── remove_worktree.bats
│   ├── main.bats
│   └── README.md
├── g-diff/                # Diff between branches
│   ├── format_diff_output.bats
│   ├── show_full_diff.bats
│   ├── show_stat_summary.bats
│   ├── main.bats
│   └── README.md
├── g-push/                # Push changes
│   └── main.bats
├── g-pull/                # Pull changes
│   └── main.bats
├── g-rto/                 # Reset to remote
│   └── main.bats
├── g-s/                   # Git status
│   └── main.bats
├── g-cb/                  # Create branch (if exists)
│   └── main.bats
└── g-co/                  # Checkout (if exists)
    └── main.bats
```

## Commands Covered

### ✅ Full Coverage (Multiple Functions Tested)

1. **g-db** (Delete Branch) - 4 test files
   - delete_local_branch
   - prompt_user_confirmation
   - prompt_remote_deletion
   - main

2. **g-wa** (Worktree Add) - 5 test files ⭐
   - generate_worktree_path (11 tests - **critical bug fix**)
   - check_branch_in_worktree
   - try_fetching_branch
   - checkout_or_create_branch
   - main

3. **g-wr** (Worktree Remove) - 5 test files
   - cd_to_worktrees_dir
   - find_worktree_by_name
   - find_worktree_by_branch
   - remove_worktree
   - main

4. **g-diff** (Diff) - 4 test files
   - format_diff_output
   - show_full_diff
   - show_stat_summary
   - main

### ✅ Main Function Tested

5. **g-push** - Tests push functionality
6. **g-pull** - Tests pull functionality
7. **g-rto** - Tests reset to remote
8. **g-s** - Tests git status
9. **g-cb** - Tests create branch (if script exists)
10. **g-co** - Tests checkout (if script exists)

## Running Tests

### Run All Command Tests
```bash
# Run all tests for all commands
bats tests/g-*/*.bats

# Run with organized output
./tests/run-tests.sh
```

### Run Specific Command
```bash
# All tests for g-db
bats tests/g-db/*.bats

# All tests for g-wa
bats tests/g-wa/*.bats

# All tests for g-wr
bats tests/g-wr/*.bats
```

### Run Specific Function
```bash
# Test specific function
bats tests/g-db/delete_local_branch.bats
bats tests/g-wa/generate_worktree_path.bats
bats tests/g-wr/cd_to_worktrees_dir.bats
```

### Run with Filter
```bash
# Test specific pattern
bats tests/g-wa/generate_worktree_path.bats --filter "nameref"
bats tests/g-wa/generate_worktree_path.bats --filter "exit code"
```

## Test Count

| Command | Functions | Test Files | Key Tests |
|---------|-----------|------------|-----------|
| g-db | 4 | 4 | Branch deletion logic |
| g-wa | 5 | 5 | **Nameref bug fix** ⭐ |
| g-wr | 5 | 5 | Worktree removal |
| g-diff | 4 | 4 | Exit code capture |
| g-push | 1 | 1 | Push workflow |
| g-pull | 1 | 1 | Pull workflow |
| g-rto | 1 | 1 | Reset to remote |
| g-s | 1 | 1 | Status display |
| g-cb | 1 | 1 | Branch creation |
| g-co | 1 | 1 | Checkout |

**Total: ~28+ test files across 10 commands**

## Critical Bug Fixes Verified

### 1. ⭐ Nameref Variable Collision (g-wa)
**File**: `tests/g-wa/generate_worktree_path.bats`
**Tests**: 11 tests including collision verification
**Fix**: Internal variable renamed from `path` to `result_path`

### 2. Exit Code Immediate Capture
**Files**: Multiple test files across all commands
**Pattern**: `local exit_var=$?` immediately after subshell
**Verified in**: All test files that use subshells

## What Each Test Verifies

### Function Tests
- ✅ Function exists and can be called
- ✅ Correct parameters are used
- ✅ Exit codes captured immediately
- ✅ Namerefs work correctly
- ✅ Dependencies are called
- ✅ Error handling works

### Main Function Tests
- ✅ Dependencies validated
- ✅ Banner printed
- ✅ Flags parsed
- ✅ Utility functions called
- ✅ Workflow executed correctly

## Adding Tests for New Commands

When adding a new gitsy command:

1. Create directory: `tests/g-newcmd/`
2. For each function in the script:
   - Create `function_name.bats`
   - Test function behavior
   - Test exit code handling
   - Test error cases
3. Always create `main.bats`
4. Create `README.md` in the directory
5. Update this file

## Example Test Template

```bash
#!/usr/bin/env bats

# Tests for function_name in g-command

setup() {
    export TEST_DIR="$(mktemp -d)"
    cd "$TEST_DIR"
    git init -q
    git config user.name "Test User"
    git config user.email "test@example.com"

    source "${BATS_TEST_DIRNAME}/../../bin/utils"
    source "${BATS_TEST_DIRNAME}/../../bin/g-command"
}

teardown() {
    rm -rf "$TEST_DIR"
}

@test "function_name: describes what it tests" {
    # Test implementation
}
```

## Documentation

- Each command directory has its own README.md
- Main test documentation: `tests/README.md`
- Utility tests: `tests/utils/README.md`
- This file: Command-specific overview

## CI/CD Integration

```yaml
- name: Run command tests
  run: |
    bats tests/g-db/*.bats
    bats tests/g-wa/*.bats
    bats tests/g-wr/*.bats
    bats tests/g-diff/*.bats
```
