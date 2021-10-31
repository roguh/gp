#!/bin/sh
# Author: Hugo O. Rivera 2021

##### All output of this script must be to stderr, except for the following
##### list of valid outputs:
NO_REMOTE_MSG="No remote"
UP_TO_DATE_MSG="Up-to-date"
NEED_TO_PULL_MSG="Need to pull"
NEED_TO_PUSH_MSG="Need to push"
DIVERGED_MSG="Diverged"

git remote update 1>&2

UPSTREAM='@{u}'
LOCAL="$(git rev-parse @)"
# Can nest double quotes when inside $()
REMOTE="$(git rev-parse "$UPSTREAM" 2>/dev/null)"
BASE="$(git merge-base @ "$UPSTREAM" 2>/dev/null)"

if [ "$DEBUG_GIT_REMOTE_STATUS" = "true" ]; then
    echo Upstream "$UPSTREAM" 1>&2
    echo Local "$LOCAL" 1>&2
    echo Remote "$REMOTE" 1>&2
    echo Base "$BASE" 1>&2
fi

if [ "$REMOTE" = "" ]; then
    echo "$NO_REMOTE_MSG"
elif [ "$LOCAL" = "$REMOTE" ]; then
    echo "$UP_TO_DATE_MSG"
elif [ "$LOCAL" = "$BASE" ]; then
    echo "$NEED_TO_PULL_MSG"
elif [ "$REMOTE" = "$BASE" ]; then
    echo "$NEED_TO_PUSH_MSG"
else
    echo "$DIVERGED_MSG"
fi
