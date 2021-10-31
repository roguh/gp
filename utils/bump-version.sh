#!/bin/sh
set -x
sed -i "s/VERSION=.*/$1/" ./gp
