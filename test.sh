#!/bin/sh
set -e

if [ "$#" != 1 ]; then
    echo "USAGE: $0 [sh|dash|bash|zsh]"
    exit 1
fi

SHELL="$1"

BRANCH0="test0-$(date +%Y-%m-%d)"
BRANCH1="test1-$(date +%Y-%m-%d)"
BRANCH2="test2-$(date +%Y-%m-%d)"

TEST_COUNT=0

set +x
end_test() {
    TEST_COUNT=$(($TEST_COUNT + 1))
}

test_echo() {
    echo [test] "$@"
}

delete_branch() {
    if [ "$2" != "local_only" ]; then
        git push origin --delete "$1"
    fi
    git checkout main
    git branch -D "$1"
}

test_echo Shell is "$SHELL"

test_echo Refuse to push new remote branch and verbose output.
set -x
git checkout -b "$BRANCH0"
./test-make-commit.sh
set +e
printf "nope\n" | "$SHELL" ./gp --verbose
if [ "$?" = 0 ]; then
    test_echo TEST FAILURE. STATUS CODE IS ZERO
fi
set -e
delete_branch "$BRANCH0" local_only
set +x
end_test

test_echo Push new remote branch.
set -x
git checkout -b "$BRANCH1"
./test-make-commit.sh
printf "\n" | "$SHELL" ./gp
delete_branch "$BRANCH1"
set +x
end_test

test_echo Push new remote branch without verification
set -x
git checkout -b "$BRANCH2"
./test-make-commit.sh
"$SHELL" ./gp --force
set +x
end_test

test_echo Push new commit on existing remote branch
set -x
./test-make-commit.sh
"$SHELL" ./gp
set +x
end_test

test_echo Avoid force pushing
set -x
git commit --amend -m 'Amended'
"$SHELL" ./gp
set +x
end_test

test_echo Please force push
set -x
git commit --amend -m 'Amended'
"$SHELL" ./gp -f
set +x
end_test

test_echo Please force push. Use alternate option
set -x
git commit --amend -m 'Amended 2'
"$SHELL" ./gp --force
set +x
end_test

test_echo Pull
set -x
git reset --hard HEAD~1
"$SHELL" ./gp
set +x
end_test

set -x
delete_branch "$BRANCH2"
set +x

test_echo End of tests.
test_echo "$TEST_COUNT" tests passed
