#!/bin/sh
docker ps -a | grep Exit | cut -d ' ' -f 1 | xargs --no-run-if-empty docker rm