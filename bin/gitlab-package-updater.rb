#! /usr/bin/env ruby

require 'git'
require 'gitlab'
require 'optparse'

require './app/cli_options'
require './app/updater/composer_updater'
require './app/updater/yarn_updater'
require './app/updater/npm_updater'
require './app/api_request'
require './app/git_action'

options = CliOptions.get

unless options[:version]
  git = GitAction.new(options)
  git.create_branch
  git.checkout

  markdown = ''

  if (File.exist?("#{options[:repo]}/composer.lock"))
    composer = ComposerUpdater.new(options)
    composer.install
    outdated = composer.outdated.to_s
    markdown << outdated unless outdated.nil?
    composer.update
  end

  if (File.exist?("#{options[:repo]}/yarn.lock"))
    yarn = YarnUpdater.new(options)
    yarn.node_version
    outdated = yarn.outdated
    markdown << outdated unless outdated.nil?
    yarn.update
  end

  if (File.exist?("#{options[:repo]}/package-lock.json"))
    npm = NpmUpdater.new(options)
    npm.node_version
    outdated = npm.outdated
    markdown << outdated unless outdated.nil?
    npm.update
  end

  if git.files_changed.count > 0
    git.add
    git.commit
    git.push

    ApiRequest.new(options, markdown).merge_request
  end
end