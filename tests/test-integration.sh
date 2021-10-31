#!/bin/sh
set -e

SCRIPT_PATH="$(dirname "$0")"

# Assuming `gp` is installed in the directory above this file's directory
PATH="$SCRIPT_PATH:$(dirname "$SCRIPT_PATH"):$PATH"

if [ "$#" != 1 ]; then
    echo "USAGE: $0 [sh|dash|bash|zsh]"
    exit 1
fi

SHELL="$1"

BRANCH0="test0-$(date +%Y-%m-%d)"
BRANCH1="test1-$(date +%Y-%m-%d)"
BRANCH2="test2-$(date +%Y-%m-%d)"

TEST_COUNT=0

end_test() {
    TEST_COUNT=$((TEST_COUNT + 1))
}

test_echo() {
    echo '[gp-test]' "$@"
}

it() {
    test_echo test \#"$TEST_COUNT": gp "$@"
}

delete_branch() {
    if [ "$2" != "local_only" ]; then
        git push origin --delete "$1"
    fi
    git checkout main
    git branch -D "$1"
}

check_in_branch() {
    if ! [ "$(git branch --show-current)" = "$1" ]; then
        test_echo TEST FAILURE. Not in expected branch "$1"
        exit 1
    fi
}

check-repo-is-clean.sh Please commit your changes before running gp tests

test_echo gp version is "$(gp --version)"
test_echo Shell is "$SHELL"

it handles help and version arguments
set -x
"$SHELL" gp --help
"$SHELL" gp -h
"$SHELL" gp --version
set +x
end_test

it handles unrecognized arguments
set +e
set -x
for args in --halp -vf nope '--help too many'; do
    if "$SHELL" gp $args; then
        test_echo TEST FAILURE. gp should not have accepted arguments "$args"
        exit 1
    fi
done
set +x
set -e
end_test

it refuses to push new remote branch with verbose output.
set -x
git checkout -b "$BRANCH0"
test-make-commit.sh
set +e
if ! printf "nope\n" | "$SHELL" gp --verbose; then
    test_echo TEST FAILURE. STATUS CODE IS ZERO
    exit 1
fi
set -e
delete_branch "$BRANCH0" local_only
set +x
end_test

it pushes new remote branch.
set -x
git checkout -b "$BRANCH1"
test-make-commit.sh
printf "\n" | "$SHELL" gp
delete_branch "$BRANCH1"
set +x
end_test

it pushes new remote branch without verification
set -x
git checkout -b "$BRANCH2"
test-make-commit.sh
"$SHELL" gp --force
set +x
end_test

it pushes new commit on existing remote branch
set -x
check_in_branch "$BRANCH2"
test-make-commit.sh
"$SHELL" gp
set +x
end_test

it avoids force pushing
set -x
check_in_branch "$BRANCH2"
git commit --amend -m 'Amended'
"$SHELL" gp
set +x
end_test

it can force push
set -x
check_in_branch "$BRANCH2"
git commit --amend -m 'Amended'
"$SHELL" gp -f
set +x
end_test

it can force push. Use alternate option
set -x
check_in_branch "$BRANCH2"
git commit --amend -m 'Amended 2'
"$SHELL" gp --force
set +x
end_test

it pulls
set -x
check_in_branch "$BRANCH2"
git reset --hard HEAD~1
"$SHELL" gp
set +x
end_test

set -x
delete_branch "$BRANCH2"
set +x

test_echo End of tests.
test_echo "$TEST_COUNT" tests passed
echo "$TEST_COUNT" > "$SCRIPT_PATH/.test-pass-count"
