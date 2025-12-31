# Gitsy Tests

This directory contains automated tests for the gitsy bash scripts using [bats-core](https://github.com/bats-core/bats-core).

## Installation

Install bats-core:
```bash
brew install bats-core
```

## Running Tests

Run all tests:
```bash
./tests/run-tests.sh
```

Run specific test file:
```bash
bats tests/utils.bats
bats tests/g-wa.bats
bats tests/exit-codes.bats
```

Run a specific test:
```bash
bats tests/utils.bats --filter "sanitize_branch_name"
```

## Test Files

- **`utils.bats`** - Tests for utility functions in `bin/utils`
  - `sanitize_branch_name` - Branch name sanitization
  - `get_current_branch` - Current branch detection
  - `get_default_branch` - Default branch detection
  - `get_repo_name` - Repository name extraction
  - `get_repo_info` - Repository information gathering
  - Exit code handling patterns

- **`g-wa.bats`** - Tests for the worktree add script (`bin/g-wa`)
  - `generate_worktree_path` - Path generation with nameref
  - Unique path generation when directories exist
  - Variable collision prevention (nameref bug fix)
  - Exit code capturing from subshells

- **`exit-codes.bats`** - Tests for exit code handling patterns
  - Immediate exit code capture after subshells
  - Exit code preservation across operations
  - Pipeline exit code handling
  - Compound command exit codes
  - All the specific patterns we fixed

## What We're Testing

### Critical Bug Fixes

1. **Nameref Variable Collision** (g-wa)
   - Tests that internal variables don't collide with nameref parameters
   - Ensures `generate_worktree_path` correctly returns values via nameref

2. **Exit Code Capturing** (all scripts)
   - Tests that exit codes are captured immediately after subshell execution
   - Prevents exit codes from being overwritten by subsequent commands
   - Pattern: `local exit_var=$?` immediately after `var=$(command)`

3. **Path Generation** (g-wa)
   - Tests unique path generation when directories exist
   - Validates absolute path conversion
   - Tests branch name sanitization and truncation

### Test Patterns

Each test follows the structure:
```bash
@test "description of what is being tested" {
    # Setup
    # Execute
    # Assert
}
```

## CI Integration

To integrate with CI, add to your workflow:

```yaml
- name: Run tests
  run: ./tests/run-tests.sh
```

## Writing New Tests

When adding new functions to gitsy scripts:

1. Create a test in the appropriate test file
2. Test both success and failure cases
3. Test exit code handling if the function uses subshells
4. Test nameref behavior if the function uses namerefs
5. Include edge cases (long names, special characters, etc.)

Example test template:
```bash
@test "function_name: description" {
    # Setup
    local expected="expected_value"

    # Execute
    local result
    function_name "input" result
    local exit_code=$?

    # Assert
    [ "$exit_code" -eq 0 ]
    [ "$result" = "$expected" ]
}
```

## Debugging Tests

Run with verbose output:
```bash
bats tests/utils.bats --tap
```

Run with trace:
```bash
bats tests/utils.bats --trace
```

Show output even on success:
```bash
bats tests/utils.bats --show-output-of-passing-tests
```
