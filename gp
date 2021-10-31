#!/bin/sh
##### Author: Hugo O. Rivera 2021
VERSION=1.0.1

set -e

##### Parameters
FORCE=false
VERBOSE=false

##### Helper functions
usage() {
  # Print usage/help
  echo "gp: Pull, push, push new branch. Version $VERSION"
  echo
  echo "USAGE: $0 [-f|--force|-h|--help]"
  echo "    -f|--force   Do not prompt for verification when pushing new branch."
  echo "                 Force push when local and remote branches diverged."
  echo "    -v|--verbose Show more output."
  echo "    --version    Show program version."
  echo "    -h|--help    Show this message."
}

verbose() {
  # Call to print verbose output
  if [ "$VERBOSE" = true ]; then
    echo gp: "$@"
  fi
}

##### Parse arguments
if [ "$#" -gt 1 ]; then
  usage
  echo "Wrong number of arguments"
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
fi

##### Check if in git repo
if ! git rev-parse --git-dir > /dev/null 2>&1; then
  echo fatal: not in a git repo >&2
  exit 1
fi

##### Get git status
REMOTE_STATUS="$(git-remote-status.sh)"

##### Push, pull, push new, force push, or do nothing
if [ "$REMOTE_STATUS" = "No remote" ]; then
  if [ "$FORCE" = "false" ]; then
    echo "No remote branch! Press ENTER to push a new remote branch"
    read -r PUSH_NEW_REMOTE_OK
    if [ "$PUSH_NEW_REMOTE_OK" != "" ] ; then
      exit 1
    fi
  fi
  set -x
  git push --set-upstream origin "$(git branch --show-current)"
elif [ "$REMOTE_STATUS" = "Need to pull" ]; then
  set -x
  git pull "$@"
elif [ "$REMOTE_STATUS" = "Need to push" ]; then
  set -x
  git push "$@"
else
  if [ "$REMOTE_STATUS" = "Diverged" ] && [ "$FORCE" = "true" ]; then
    verbose FORCE PUSHING
    set -x
    git push "$@"
    set +x
  fi
  verbose Not running any commands
  echo "$REMOTE_STATUS"
fi
