#!/bin/sh
CHANGES_TO_GIT_FILES="$(git status --porcelain | grep -v "^?? ")"
if ! [ "$CHANGES_TO_GIT_FILES" = "" ]; then
    echo "$@"
    exit 1
fi

