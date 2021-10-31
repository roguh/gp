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

    echo 0 > .test-pass-count

    TEST_OUTPUT="test-results.$TEST_SHELL.txt"
    test_echo "$TEST_SHELL" ./test.sh "$TEST_SHELL"
    "$TEST_SHELL" ./test.sh "$TEST_SHELL" > "$TEST_OUTPUT" 2>&1

    if [ "$?" = 0 ]; then
        test_echo "SHELL=$TEST_SHELL Tests passed"
    else
        test_echo "SHELL=$TEST_SHELL Tests failed"
    fi

    TEST_COUNT="$(cat .test-pass-count)"
    test_echo "SHELL=$TEST_SHELL $TEST_COUNT tests passed. Output in $TEST_OUTPUT"
    TOTAL_TESTS_PASSED=$(($TOTAL_TESTS_PASSED + $TEST_COUNT))
done

test_echo Testing finished successfully
test_echo "$TOTAL_TESTS_PASSED" tests passed in total
