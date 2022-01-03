#!/usr/bin/env bash

set -e
set -x

mkdir /tmp/toto
cd /tmp/toto
python -m http.server 8080
