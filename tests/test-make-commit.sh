#!/bin/sh
set -x
echo test >> ./test-file
git add ./test-file
git commit -m 'test commit'
