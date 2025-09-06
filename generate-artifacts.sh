#!/usr/bin/env sh
set -e
rm -rf build
docker build -t ols .
trap "docker rm -f ols" EXIT
docker create --name ols ols
docker cp ols:ols/build build
