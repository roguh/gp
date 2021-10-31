#!/bin/sh
SCRIPT_PATH="$(dirname "$0")"
PATH="$SCRIPT_PATH:$PATH"

if [ "$#" = 0 ]; then
    echo "USAGE: $0 shell1 shell2 ..."
    echo "    Example: $0 sh bash"
    exit 1
fi

TOTAL_TESTS_PASSED=0
TOTAL_DURATION=0
SHELL_COUNT=0
TESTS_FAILED=false

test_echo() {
    echo '[gp-all-test]' "$@"
}

if ! check-repo-is-clean.sh Please commit your changes before running gp tests; then
    exit 1
fi

for TEST_SHELL in "$@"; do
    if ! command -v "$TEST_SHELL" > /dev/null; then
        test_echo "$TEST_SHELL" not installed. Skipping tests.
        continue
    fi

    SHELL_COUNT=$((SHELL_COUNT + 1))

    echo 0 > "$SCRIPT_PATH/.test-pass-count"

    START_TIME=$(date +%s)

    NICE_SHELL_NAME="$(echo "$TEST_SHELL" | sed 's/\.*\//_/g')"
    TEST_OUTPUT="$SCRIPT_PATH/test-results.$NICE_SHELL_NAME.txt"
    test_echo Running: "$TEST_SHELL" "$SCRIPT_PATH/test.sh" "$TEST_SHELL"
    if "$TEST_SHELL" "$SCRIPT_PATH/test.sh" "$TEST_SHELL" > "$TEST_OUTPUT" 2>&1; then
        test_echo "SHELL=$TEST_SHELL Tests passed"
    else
        test_echo "SHELL=$TEST_SHELL Tests failed"
        TESTS_FAILED=true
    fi

    TEST_COUNT="$(cat "$SCRIPT_PATH/.test-pass-count")"
    DURATION=$(($(date +%s) - START_TIME))
    TOTAL_DURATION=$((TOTAL_DURATION + DURATION))
    test_echo "SHELL=$TEST_SHELL $TEST_COUNT tests passed in $DURATION seconds. Output in $TEST_OUTPUT"
    TOTAL_TESTS_PASSED=$((TOTAL_TESTS_PASSED + TEST_COUNT))
done

test_echo Testing "$SHELL_COUNT" shells finished successfully in "$TOTAL_DURATION" seconds
test_echo "$TOTAL_TESTS_PASSED" tests passed in total
if [ "$TESTS_FAILED" = true ]; then
    test_echo SOME TESTS FAILED
    test_echo Make sure to remove any test branches from your repo that were left behind.
    exit 1
fi
