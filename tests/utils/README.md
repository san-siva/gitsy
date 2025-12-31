# Utils Function Tests

This directory contains individual test files for each function in `bin/utils`.

## Test Files

Each function has its own test file:

- **`get_current_branch.bats`** - Tests for getting current git branch
  - Returns correct branch name
  - Handles exit codes properly
  - Works with feature/release branches
  - Nameref parameter works correctly

- **`get_default_branch.bats`** - Tests for getting default branch
  - Falls back to 'main' when no remote
  - Detects main/master branches
  - Captures git symbolic-ref exit code

- **`sanitize_branch_name.bats`** - Tests for branch name sanitization
  - Converts special characters to underscores
  - Converts to lowercase
  - Truncates long names
  - Handles real-world JIRA branch names

- **`get_repo_name.bats`** - Tests for extracting repository name
  - Extracts from HTTPS URLs
  - Extracts from SSH URLs
  - Handles various Git providers (GitHub, GitLab, Enterprise)
  - Captures sed pipeline exit code

- **`get_repo_info.bats`** - Tests for getting repository information
  - Populates all nameref variables correctly
  - Returns git root, current dir, parent dir, repo name
  - Captures git rev-parse exit code

- **`stash_changes.bats`** - Tests for stashing changes
  - Stashes when flag is true
  - Skips when flag is false
  - Captures branch name exit code
  - Includes custom messages

- **`branch_exists_locally.bats`** - Tests for local branch detection
  - Returns true for existing branches
  - Returns false for non-existent branches
  - Case sensitive checking

- **`branch_exists_on_remote.bats`** - Tests for remote branch detection
  - Returns false when no remote
  - Checks remote branch existence

## Running Tests

Run all utils tests:
```bash
bats tests/utils/*.bats
```

Run a specific function test:
```bash
bats tests/utils/get_current_branch.bats
bats tests/utils/sanitize_branch_name.bats
```

Run with filter:
```bash
bats tests/utils/sanitize_branch_name.bats --filter "converts"
```

## Test Structure

Each test file follows this structure:

```bash
#!/usr/bin/env bats

setup() {
    # Create temp directory
    # Initialize git repo
    # Source utils file
}

teardown() {
    # Clean up temp directory
}

@test "function_name: what it tests" {
    # Test implementation
}
```

## Key Patterns Tested

### 1. Exit Code Capturing
All tests verify that exit codes are captured immediately:
```bash
result=$(command)
local exit_code=$?  # Captured immediately
```

### 2. Nameref Parameters
Tests ensure nameref parameters work correctly:
```bash
local my_var
function_name my_var
[ -n "$my_var" ]  # Verify nameref worked
```

### 3. Real-World Scenarios
Tests include real-world examples:
- JIRA branch names: `EXT-5994__template_changes...`
- Feature branches: `feature/test-feature`
- Release branches: `release/1.0.0`

## Adding New Tests

When adding tests for a new function:

1. Create `function_name.bats` in this directory
2. Include setup/teardown
3. Test success cases
4. Test failure cases
5. Test exit code handling
6. Test nameref behavior (if applicable)
7. Include edge cases
