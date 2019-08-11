#!/bin/bash

echo "PHP Default:           " `php -v` || exit 1
echo "PHP 7.1:               " `/usr/bin/php7.1 -v` || exit 1
echo "PHP 7.2:               " `/usr/bin/php7.2 -v` || exit 1
echo "PHP 7.3:               " `/usr/bin/php7.3 -v` || exit 1
echo "Composer:              " `composer --version` || exit 1
echo "Ruby:                  " `ruby --version` || exit 1
echo "Ruby Gems:             " `gem --version` || exit 1
echo "Node:                  " `node --version` || exit 1
echo "NVM:                   " `. /root/.nvm/nvm.sh && nvm --version` || exit 1
echo "NPM:                   " `. /root/.nvm/nvm.sh && npm --version` || exit 1
echo "RVM:                   " `rvm -v` || exit 1
echo "Yarn:                  " `yarn --version` || exit 1
echo "Gitlab Package Updater:" `gitlab-package-updater.rb -v` || exit 1
