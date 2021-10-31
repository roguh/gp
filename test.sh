#!/bin/sh
set -e

if [ "$#" != 1 ]; then
    echo "USAGE: $0 [sh|dash|bash|zsh]"
    exit 1
fi

SHELL="$1"

BRANCH1="test1-$(date +%Y-%m-%d)"
BRANCH2="test2-$(date +%Y-%m-%d)"

test_echo() {
    echo [test] "$@"
}

delete_branch() {
    git push origin --delete "$1"
    git checkout main
    git branch -D "$1"
}

test_echo Shell is "$(ps -p $$)"

test_echo Push new remote branch. Remember to press ENTER
set -x
git checkout -b "$BRANCH1"
./test-make-commit.sh
"$SHELL" ./gp
delete_branch "$BRANCH1"
set +x

test_echo Push new remote branch without verification
set -x
git checkout -b "$BRANCH2"
./test-make-commit.sh
"$SHELL" ./gp --force
set +x

test_echo Push new commit on existing remote branch
set -x
./test-make-commit.sh
"$SHELL" ./gp
set +x

test_echo Avoid force pushing
set -x
git commit --amend -m 'Amended'
"$SHELL" ./gp
set +x

test_echo Please force push
set -x
git commit --amend -m 'Amended'
"$SHELL" ./gp -f
set +x

test_echo Please force push. Use alternate option
set -x
git commit --amend -m 'Amended 2'
"$SHELL" ./gp --force
set +x

test_echo Pull
set -x
git reset --hard HEAD~1
"$SHELL" ./gp
set +x

test_echo End of tests
set -x
delete_branch "$BRANCH2"
set +x
