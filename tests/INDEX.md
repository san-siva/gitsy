# Gitsy Test Suite Index

## Directory Structure

```
tests/
├── utils/                              # Individual function tests
│   ├── branch_exists_locally.bats      # Local branch detection
│   ├── branch_exists_on_remote.bats    # Remote branch detection
│   ├── get_current_branch.bats         # Current branch retrieval
│   ├── get_default_branch.bats         # Default branch detection
│   ├── get_repo_info.bats              # Repository information
│   ├── get_repo_name.bats              # Repository name extraction
│   ├── sanitize_branch_name.bats       # Branch name sanitization (✅ 14/14 passing)
│   ├── stash_changes.bats              # Stash operations
│   └── README.md                       # Utils tests documentation
├── g-wa.bats                           # Worktree add script tests
├── exit-codes.bats                     # Exit code pattern tests
├── utils.bats                          # Original combined utils tests
├── run-tests.sh                        # Main test runner
├── README.md                           # Test suite documentation
├── SUMMARY.md                          # Test results summary
└── INDEX.md                            # This file

## Quick Start

### Run All Tests
```bash
./tests/run-tests.sh
```

### Run Specific Function Tests
```bash
# Single function
bats tests/utils/sanitize_branch_name.bats

# All utils functions
bats tests/utils/*.bats

# With filter
bats tests/utils/get_current_branch.bats --filter "nameref"
```

### Run Script Tests
```bash
bats tests/g-wa.bats
bats tests/exit-codes.bats
```

## Test Coverage

### ✅ Fully Tested Functions (with separate test files)

1. **sanitize_branch_name** - 14 tests
   - Special character conversion
   - Lowercase conversion
   - Truncation logic
   - Real-world JIRA branches
   - Exit code handling
   - Nameref functionality

2. **get_current_branch** - 7 tests
   - Branch name retrieval
   - Exit code capturing
   - Various branch types
   - Nameref parameters

3. **get_default_branch** - 6 tests
   - Default branch detection
   - Fallback logic
   - Exit code handling

4. **get_repo_name** - 13 tests
   - URL parsing (HTTPS, SSH)
   - Various Git providers
   - Exit code from sed pipeline

5. **get_repo_info** - 8 tests
   - All nameref variables
   - Exit code capturing
   - Path validation

6. **stash_changes** - 6 tests
   - Stash operations
   - Branch name capturing
   - Message formatting

7. **branch_exists_locally** - 6 tests
   - Local branch detection
   - Case sensitivity

8. **branch_exists_on_remote** - 2 tests
   - Remote branch detection

### 🔧 Script Tests

9. **g-wa (worktree add)** - 15 tests
   - Path generation
   - Nameref collision fix
   - Unique path generation
   - Exit code handling

10. **Exit code patterns** - 30+ tests
    - Immediate capture pattern
    - All fixed patterns from bug fixes
    - Pipeline handling

## Test Statistics

- **Total Test Files**: 11
- **Total Tests**: 100+
- **Coverage**: Critical functions and bug fixes
- **Framework**: bats-core 1.13.0

## Critical Bug Fixes Verified

### ✅ 1. Nameref Variable Collision (g-wa)
**File**: `tests/g-wa.bats`
```bash
@test "generate_worktree_path: no variable collision with nameref"
```
Verifies that internal `path` variable doesn't collide with nameref parameter.

### ✅ 2. Exit Code Immediate Capture
**Files**: All test files
```bash
result=$(command)
local exit_var=$?  # Captured immediately
```
Every test verifies exit codes are captured before any other operations.

### ✅ 3. Branch Name Sanitization
**File**: `tests/utils/sanitize_branch_name.bats`
14 tests covering all edge cases including:
- Long JIRA branch names
- Special characters
- Truncation logic

## Adding New Tests

### For a new utility function:
1. Create `tests/utils/function_name.bats`
2. Follow the existing test structure
3. Include setup/teardown
4. Test success, failure, and edge cases

### For a new script:
1. Create `tests/script-name.bats`
2. Test main functionality
3. Test error handling
4. Test exit code patterns

## CI/CD Integration

Add to your CI pipeline:
```yaml
- name: Install bats
  run: brew install bats-core

- name: Run tests
  run: ./tests/run-tests.sh
```

## Documentation

- **tests/README.md** - Main test suite documentation
- **tests/utils/README.md** - Utils function tests
- **tests/SUMMARY.md** - Test results and status
- **tests/INDEX.md** - This file (navigation guide)

## Test Philosophy

1. **One function = One file**: Each utility function has its own test file
2. **Immediate exit code capture**: All tests verify the pattern we fixed
3. **Real-world scenarios**: Tests include actual JIRA branches and Git URLs
4. **Nameref validation**: All functions using namerefs are tested thoroughly
5. **Comprehensive coverage**: Success, failure, and edge cases

## Running Tests During Development

```bash
# Watch mode (using entr or similar)
ls tests/utils/*.bats | entr bats tests/utils/sanitize_branch_name.bats

# Specific test pattern
bats tests/utils/sanitize_branch_name.bats --filter "JIRA"

# Verbose output
bats tests/utils/get_current_branch.bats --tap

# Show output even on pass
bats tests/utils/*.bats --show-output-of-passing-tests
```

## Maintenance

- Update tests when adding new functions to `bin/utils`
- Add regression tests for any bugs found
- Keep test files focused on single functions
- Document complex test scenarios
