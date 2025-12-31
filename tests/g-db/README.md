# Tests for g-db (Delete Branch)

Tests for the `bin/g-db` script - delete a branch locally and optionally on remote.

## Functions Tested

- **`delete_local_branch.bats`** - Tests for deleting local branches
  - Deletes existing branch
  - Returns success for non-existent branch
  - Prevents deletion of current branch
  - Uses get_current_branch correctly

- **`prompt_user_confirmation.bats`** - Tests for user confirmation prompt
  - Calls prompt_user with correct parameters
  - Uses prompt_user from utils

- **`prompt_remote_deletion.bats`** - Tests for remote deletion prompt
  - Returns success when no remote branch exists
  - Checks branch_exists_on_remote

- **`main.bats`** - Tests for main function
  - Validates dependencies
  - Calls set_flags
  - Prints banner
  - Checks if target branch is set

## Running Tests

```bash
# Run all g-db tests
bats tests/g-db/*.bats

# Run specific function test
bats tests/g-db/delete_local_branch.bats
bats tests/g-db/main.bats
```
