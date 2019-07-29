#! /usr/bin/env ruby

# Fix the PATH so that gitlab-shell can find git-upload-pack and friends.
# ENV['PATH'] = '/opt/gitlab/bin:/opt/gitlab/embedded/bin:' + ENV['PATH']
#
# require 'net/http'
# require 'json'
# require 'cgi'

require 'git'
require 'gitlab'
require 'optparse'
require './src/cli_options'
require './src/general_updater'
require './src/composer_updater'
require './src/yarn_updater'
require './src/npm_updater'

options = CliOptions.get

if (File.exist?("#{options[:repo]}/composer.lock"))
  composer = ComposerUpdater.new(options)
  composer.install
  composer.outdated
  composer.update
end

if (File.exist?("#{options[:repo]}/yarn.lock"))
  yarn = YarnUpdater.new(options)
  yarn.outdated
  yarn.update
end

if (File.exist?("#{options[:repo]}/package-lock.json"))
  npm = NpmUpdater.new(options)
  npm.outdated
  npm.update
end

# Gitlab.create_branch()


