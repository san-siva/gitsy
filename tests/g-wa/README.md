# Tests for g-wa (Worktree Add)

Tests for the `bin/g-wa` script - create git worktree for branch.

## Functions Tested

- **`generate_worktree_path.bats`** - ✅ Critical bug fix verified
  - Generates path correctly
  - Returns via nameref correctly
  - **NO variable collision with nameref** (bug fix)
  - Uses result_path internally (not path)
  - Captures exit code from cd command
  - Handles long branch names (JIRA style)
  - Generates unique paths when directory exists
  - Captures find command exit code
  - Validates absolute path conversion

- **`check_branch_in_worktree.bats`** - Tests for worktree checking
  - Captures git worktree list exit code
  - Handles non-existent branch
  - Checks if branch exists in worktree list

- **`try_fetching_branch.bats`** - Tests for branch fetching
  - Calls fetch_changes
  - Uses target_branch variable

- **`checkout_or_create_branch.bats`** - Tests for branch operations
  - Calls check_branch_in_worktree
  - Calls generate_worktree_path
  - Handles generate_worktree_path failure

- **`main.bats`** - Tests for main function
  - Validates dependencies
  - Calls print_banner
  - Checks if target branch is set
  - Checks if in git repo
  - Calls stash_changes
  - Gets default and current branch

## Critical Bug Fix Verified

### Nameref Variable Collision
The `generate_worktree_path` function had a critical bug where the internal variable `path` collided with the nameref parameter. This caused the function to return an empty value.

**Fixed by**: Renaming internal variable to `result_path`
**Verified by**: `generate_worktree_path.bats` - 11 tests

## Running Tests

```bash
# Run all g-wa tests
bats tests/g-wa/*.bats

# Run specific function test
bats tests/g-wa/generate_worktree_path.bats
bats tests/g-wa/main.bats

# Test the critical bug fix
bats tests/g-wa/generate_worktree_path.bats --filter "collision"
```
