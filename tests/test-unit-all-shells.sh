#!/bin/sh
if [ "$#" = 0 ]; then
    echo "USAGE: $0 [SHELLS...]"
    echo
    echo "SHELLS can be a list of any installed shells"
    echo "Examples: bash, zsh, dash, yash"
    exit 1
fi

set -e
for shell in "$@"; do
    "$(dirname "$0")/test-unit.sh" "$shell"
done
