#!/bin/sh
##### Author: Hugo O. Rivera 2021
VERSION=1.3.6

set -e

##### Parameters
FORCE=false
VERBOSE=false

##### Helper functions
usage() {
  # Print usage/help
  echo "gp: Pull, push, push new branch. Version $VERSION"
  echo
  echo "- If there are changes in the remote branch, pull"
  echo "- If there are changes in the local branch, push"
  echo "- If there is no remote branch, prompt to push a new branch."
  echo "  Skip prompt with gp -f"
  echo "- If the branches have diverged, do nothing."
  echo "  Force push with gp -f"
  echo
  echo "USAGE: gp [-f|-v|-h|--version]"
  echo "    -f|--force   Do not prompt for verification when pushing new branch."
  echo "                 Force push when local and remote branches diverged."
  echo "    -v|--verbose Show more output."
  echo "    -h|--help    Show this message."
  echo "    --version    Show program version."
}

log() {
  echo "$@" >&2
}

verbose() {
  # Call to print verbose output
  if [ "$VERBOSE" = true ]; then
    log "gp:" "$@"
  fi
}

run() {
  log "+ " "$@"
  "$@"
}

##### Parse arguments
if [ "$#" -gt 1 ]; then
  usage
  echo "ERROR: Wrong number of arguments"
  exit 1
fi

if [ "$1" = "-f" ] || [ "$1" = "--force" ]; then
  FORCE=true
elif [ "$1" = "-v" ] || [ "$1" = "--verbose" ]; then
  VERBOSE=true
elif [ "$1" = "--version" ]; then
  echo "$VERSION"
  exit 0
elif [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
  usage
  exit 0
elif [ "$1" = "" ]; then
  true
else
  usage
  echo "ERROR: Unrecognized argument $1"
  exit 1
fi

##### Check if in git repo
if ! git rev-parse --git-dir > /dev/null 2>&1; then
  echo fatal: not in a git repo >&2
  exit 1
fi

##### Get git status
run git remote update

set +e
UPSTREAM='@{u}'
LOCAL="$(git rev-parse @)"
# Can nest double quotes when inside $()
REMOTE="$(git rev-parse "$UPSTREAM" 2>/dev/null)"
BASE="$(git merge-base @ "$UPSTREAM" 2>/dev/null)"
set -e

if [ "$DEBUG_GIT_REMOTE_STATUS" = "true" ]; then
    echo Upstream "$UPSTREAM" >&2
    echo Local "$LOCAL" >&2
    echo Remote "$REMOTE" >&2
    echo Base "$BASE" >&2
fi

REMOTE_STATUS="Unknown"
if [ "$REMOTE" = "" ]; then
    REMOTE_STATUS="No remote"
elif [ "$LOCAL" = "$REMOTE" ]; then
    REMOTE_STATUS="Up-to-date"
elif [ "$LOCAL" = "$BASE" ]; then
    REMOTE_STATUS="Need to pull"
elif [ "$REMOTE" = "$BASE" ]; then
    REMOTE_STATUS="Need to push"
else
    REMOTE_STATUS="Diverged"
fi

##### Push, pull, push new, force push, or do nothing
if [ "$REMOTE_STATUS" = "No remote" ]; then
  if [ "$FORCE" = "false" ]; then
    echo "No remote branch! Press ENTER to push a new remote branch"
    read -r PUSH_NEW_REMOTE_OK
    if [ "$PUSH_NEW_REMOTE_OK" != "" ] ; then
      exit 1
    fi
  fi
  run git push --set-upstream origin "$(git branch --show-current)"
elif [ "$REMOTE_STATUS" = "Need to pull" ]; then
  run git pull
elif [ "$REMOTE_STATUS" = "Need to push" ]; then
  run git push
elif [ "$REMOTE_STATUS" = "Diverged" ]; then
  if [ "$FORCE" = "true" ]; then
    verbose FORCE PUSHING
    run git push --force
  else
    verbose Not running any commands
    log "$REMOTE_STATUS"
  fi
else
  verbose Not running any commands
  log "$REMOTE_STATUS"
fi
