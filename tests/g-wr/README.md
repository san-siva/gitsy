# Tests for g-wr (Worktree Remove)

Tests for the `bin/g-wr` script - remove a git worktree for a specified branch or name.

## Functions Tested

- **`cd_to_worktrees_dir.bats`** - Tests for navigating to worktrees directory
  - Captures git rev-parse exit code immediately
  - Gets git root correctly

- **`find_worktree_by_name.bats`** - Tests for finding worktree by name
  - Function exists
  - Calls cd_to_worktrees_dir

- **`find_worktree_by_branch.bats`** - Tests for finding worktree by branch
  - Captures git rev-parse exit code
  - Checks target branch is set

- **`remove_worktree.bats`** - Tests for removing worktree
  - Function exists
  - Takes worktree path and step number

- **`main.bats`** - Tests for main function
  - Validates dependencies
  - Prints banner
  - Calls stash_changes
  - Calls find_dir_to_remove

## Running Tests

```bash
# Run all g-wr tests
bats tests/g-wr/*.bats

# Run specific function test
bats tests/g-wr/cd_to_worktrees_dir.bats
bats tests/g-wr/main.bats
```
