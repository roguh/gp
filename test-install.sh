#!/bin/sh
if command -v gp > /dev/null; then
    echo Command gp not found
    echo Check to make sure gp is in your PATH "$1"
fi

if ! gp -h; then
    echo Command gp found, but failed to run
fi
