#!/bin/sh
set -x
sed -i "s/VERSION=.*/VERSION=$1/" ./gp
