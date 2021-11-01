#!/bin/sh
if [ "$#" = 0 ]; then
    echo USAGE: $0 [SHELLS...]
    echo SHELLS can be any installed shells, such as bash, zsh, dash, yash, etc.
    exit 1
fi

set -e
for shell in "$@"; do
    "$(dirname "$0")/test-unit.sh" "$shell"
done
