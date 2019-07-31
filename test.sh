#!/bin/bash

echo "Composer:              " `composer --version` || exit 1
echo "Ruby:                  " `ruby --version` || exit 1
echo "Ruby Gems:             " `gem --version` || exit 1
echo "Node:                  " `node --version` || exit 1
echo "NVM:                   " `. /root/.nvm/nvm.sh && nvm --version` || exit 1
echo "rbenv:                 " `rbenv --version` || exit 1
echo "NPM:                   " `npm --version` || exit 1
echo "Yarn:                  " `yarn --version` || exit 1
echo "Gitlab Package Updater:" `gitlab-package-updater.rb -v` || exit 1
