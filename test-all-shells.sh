#!/bin/sh
TOTAL_TESTS_PASSED=0

test_echo() {
    echo [gp-all-test] "$@"
}

for TEST_SHELL in sh dash bash zsh; do
    if ! command -v "$TEST_SHELL" > /dev/null; then
        test_echo "$TEST_SHELL" not installed. Skipping tests.
        continue
    fi

    TEST_OUTPUT="test-results.$TEST_SHELL.txt"
    ./test.sh "$TEST_SHELL" > "$TEST_OUTPUT" 2>&1

    TEST_COUNT="$(cat .test-pass-count)"
    test_echo "$TEST_COUNT tests passed. Output in $TEST_OUTPUT"
    TOTAL_TESTS_PASSED=$(($TOTAL_TESTS_PASSED + $TEST_COUNT))
done

test_echo Testing finished successfully
test_echo "$TOTAL_TESTS_PASSED" tests passed in total
