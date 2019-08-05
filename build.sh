#!/bin/bash

docker build --no-cache --pull . -f Dockerfile -t ochorocho/gitlab-package-updater:latest && docker run --rm -it -v `pwd`/test.sh:/tmp/test.sh ochorocho/gitlab-package-updater:latest /tmp/test.sh
