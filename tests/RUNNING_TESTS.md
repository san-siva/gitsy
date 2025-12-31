# Running Gitsy Tests

## Quick Start

Run all tests:
```bash
./tests/run-tests.sh
```

## Test Structure

The test suite is organized into two main categories:

### 1. Utility Functions (tests/utils/)
Individual test files for each utility function in `bin/utils`:
- `branch_exists_locally.bats` - 6 tests
- `branch_exists_on_remote.bats` - 2 tests
- `get_current_branch.bats` - 7 tests
- `get_default_branch.bats` - 6 tests
- `get_repo_info.bats` - 8 tests
- `get_repo_name.bats` - 12 tests
- `sanitize_branch_name.bats` - 14 tests
- `stash_changes.bats` - 6 tests

### 2. Command Scripts (tests/g-*/)
Individual test files for each function within each command:

**g-db/** (Delete Branch):
- `delete_local_branch.bats`
- `prompt_user_confirmation.bats`
- `prompt_remote_deletion.bats`
- `main.bats`

**g-wa/** (Worktree Add):
- `generate_worktree_path.bats`
- `check_branch_in_worktree.bats`
- `try_fetching_branch.bats`
- `checkout_or_create_branch.bats`
- `main.bats`

**g-wr/** (Worktree Remove):
- `cd_to_worktrees_dir.bats`
- `find_worktree_by_name.bats`
- `find_worktree_by_branch.bats`
- `remove_worktree.bats`
- `main.bats`

**g-diff/** (Diff):
- `format_diff_output.bats`
- `show_full_diff.bats`
- `show_stat_summary.bats`
- `main.bats`

**Other Commands:**
- `g-push/main.bats`
- `g-pull/main.bats`
- `g-rto/main.bats`
- `g-s/main.bats`
- `g-cb/main.bats`
- `g-co/main.bats`

## Running Specific Tests

### Run all tests for a specific utility function:
```bash
bats tests/utils/sanitize_branch_name.bats
```

### Run all tests for a specific command:
```bash
bats tests/g-db/*.bats
bats tests/g-wa/*.bats
```

### Run a specific test file:
```bash
bats tests/g-wa/generate_worktree_path.bats
```

### Run with a filter (specific test names):
```bash
bats tests/g-wa/generate_worktree_path.bats --filter "nameref"
```

## Test Output

The test runner shows:
- Individual test results for each test file
- Summary of test files (total, passed, failed)
- Summary of individual tests (total, passed, failed)
- Overall success rate

Example output:
```
=========================================
 TEST SUMMARY
=========================================

Test Files:
  Total: 32
  Passed: 20
  Failed: 12

Individual Tests:
  Total: 145
  Passed: 115
  Failed: 30

Success Rate: 79.3%
⚠️  Some test files have failures

=========================================
```

## Current Test Status

As of the latest run:
- ✅ **32 test files** covering utility functions and commands
- ✅ **145 individual tests**
- ✅ **79.3% success rate**

### Fully Passing Test Files:
- `sanitize_branch_name.bats` - 14/14 tests ✅
- `get_repo_name.bats` - 12/12 tests ✅
- `branch_exists_locally.bats` - 6/6 tests ✅
- `branch_exists_on_remote.bats` - 2/2 tests ✅
- `get_current_branch.bats` - 7/7 tests ✅

## Archived Tests

Old monolithic test files have been archived to `tests/archive/`:
- `utils.bats` (replaced by granular utility tests)
- `g-wa.bats` (replaced by granular g-wa tests)
- `exit-codes.bats` (exit code patterns now verified in all tests)

## Adding New Tests

When adding a new gitsy command:
1. Create directory: `tests/g-newcmd/`
2. Create test file for each function: `function_name.bats`
3. Create `main.bats` for the main workflow
4. Tests will be automatically picked up by `./tests/run-tests.sh`

See existing test files for examples and patterns.
