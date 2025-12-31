#!/usr/bin/env bash

# Test runner script for gitsy
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "========================================="
echo "     GITSY TEST SUITE"
echo "========================================="
echo ""

# Check if bats is installed
if ! command -v bats &> /dev/null; then
    echo "Error: bats-core is not installed"
    echo "Install it with: brew install bats-core"
    exit 1
fi

total_test_files=0
total_passed_files=0
total_failed_files=0
total_tests=0
total_passed_tests=0
total_failed_tests=0

# Run utility function tests
echo "========================================="
echo " 1. UTILITY FUNCTIONS"
echo "========================================="
echo ""

for test_file in "$SCRIPT_DIR"/utils/*.bats; do
    if [ -f "$test_file" ]; then
        ((total_test_files++))
        test_name=$(basename "$test_file" .bats)
        echo "→ Testing: $test_name"

        # Run tests and capture output
        if output=$(bats "$test_file" 2>&1); then
            ((total_passed_files++))
            # Count individual tests
            test_count=$(echo "$output" | grep -c "^ok" || true)
            ((total_tests += test_count))
            ((total_passed_tests += test_count))
            echo "$output"
        else
            ((total_failed_files++))
            # Count passed and failed individual tests
            test_count=$(echo "$output" | grep -cE "^(ok|not ok)" || true)
            passed_count=$(echo "$output" | grep -c "^ok" || true)
            failed_count=$(echo "$output" | grep -c "^not ok" || true)
            ((total_tests += test_count))
            ((total_passed_tests += passed_count))
            ((total_failed_tests += failed_count))
            echo "$output"
        fi
        echo ""
    fi
done

# Run command tests
echo "========================================="
echo " 2. COMMAND SCRIPTS"
echo "========================================="
echo ""

# Test each command directory
for cmd_dir in "$SCRIPT_DIR"/g-*/; do
    if [ -d "$cmd_dir" ]; then
        cmd_name=$(basename "$cmd_dir")
        echo "→ Testing: $cmd_name"

        for test_file in "$cmd_dir"/*.bats; do
            if [ -f "$test_file" ]; then
                ((total_test_files++))
                test_func=$(basename "$test_file" .bats)
                echo "  ├─ $test_func"

                # Run tests and capture output
                if output=$(bats "$test_file" 2>&1); then
                    ((total_passed_files++))
                    # Count individual tests
                    test_count=$(echo "$output" | grep -c "^ok" || true)
                    ((total_tests += test_count))
                    ((total_passed_tests += test_count))
                    echo "$output" | sed 's/^/     /'
                else
                    ((total_failed_files++))
                    # Count passed and failed individual tests
                    test_count=$(echo "$output" | grep -cE "^(ok|not ok)" || true)
                    passed_count=$(echo "$output" | grep -c "^ok" || true)
                    failed_count=$(echo "$output" | grep -c "^not ok" || true)
                    ((total_tests += test_count))
                    ((total_passed_tests += passed_count))
                    ((total_failed_tests += failed_count))
                    echo "$output" | sed 's/^/     /'
                fi
            fi
        done
        echo ""
    fi
done

# Summary
echo "========================================="
echo " TEST SUMMARY"
echo "========================================="
echo ""
echo "Test Files:"
echo "  Total: $total_test_files"
echo "  Passed: $total_passed_files"
if [ "$total_failed_files" -gt 0 ]; then
    echo "  Failed: $total_failed_files"
fi
echo ""
echo "Individual Tests:"
echo "  Total: $total_tests"
echo "  Passed: $total_passed_tests"
if [ "$total_failed_tests" -gt 0 ]; then
    echo "  Failed: $total_failed_tests"
fi
echo ""

if [ "$total_failed_files" -eq 0 ] && [ "$total_failed_tests" -eq 0 ]; then
    echo "🎉 All tests passed!"
    success_rate="100%"
else
    success_rate=$(awk "BEGIN {printf \"%.1f\", ($total_passed_tests / $total_tests) * 100}")
    echo "Success Rate: ${success_rate}%"
    if [ "$total_failed_files" -gt 0 ]; then
        echo "⚠️  Some test files have failures"
    fi
fi
echo ""
echo "========================================="

if [ "$total_failed_files" -gt 0 ] || [ "$total_failed_tests" -gt 0 ]; then
    exit 1
else
    exit 0
fi
