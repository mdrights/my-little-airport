#!/usr/bin/env sh
curl -# -O -u<user>:<token> \
    -T $1 \
    https://artifactory.xxxconnect.net/artifactory/generic-local/
