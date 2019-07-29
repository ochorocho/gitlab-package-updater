#!/bin/bash

docker build --pull . -f Dockerfile -t ochorocho/gitlab-package-updater:latest && docker run --rm -it -v `pwd`/test.sh:/tmp/test.sh --entrypoint "ash" ochorocho/gitlab-package-updater:latest /tmp/test.sh
