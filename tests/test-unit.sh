#!/bin/sh
if [ "$#" != 1 ]; then
    echo USAGE: $0 [SHELL]
    echo SHELL can be any installed shell, such as bash, zsh, dash, yash, etc.
    exit 1
fi
"$(dirname "$0")/shellspec/shellspec" --shell "$1" --helperdir tests/unit_tests/spec --sandbox tests/unit_tests/gp_spec.sh
