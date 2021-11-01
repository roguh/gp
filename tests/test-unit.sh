#!/bin/sh
if [ "$#" != 1 ]; then
    echo "USAGE: $0 [SHELL]"
    echo
    echo "SHELL can be any installed shells"
    echo "Examples: bash, zsh, dash, yash"
    exit 1
fi
"$(dirname "$0")/shellspec/shellspec" --shell "$1" --helperdir tests/unit_tests/spec --sandbox --jobs 4 tests/unit_tests/gp_spec.sh
