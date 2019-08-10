require_relative 'general_updater'

class ComposerUpdater < GeneralUpdater
  OUTPUT_FORMAT = "json".freeze

  def install
    system("composer install -d #{@options[:repo]}")
  end

  def outdated
    packages = `composer outdated -f #{OUTPUT_FORMAT} -d #{@options[:repo]}`
    parse_to_markdown(packages)
  end

  def update
    `composer update -d #{@options[:repo]}`
  end

  private

  def parse_to_markdown(json)
    json = JSON.parse(json)
    keys = json.first[1][0].keys

    table = "\n### Composer\n\n"
    table += headline(keys)
    table += headline_seperator(keys)
    table += row(json.first[1], keys)

    table
  end

  def row(json, keys)
    rows = ''
    json.each do |package|
      next unless package['latest-status'] == 'semver-safe-update'
      rows += '| '
      keys.each do |field|
        rows += "#{package[field]} | "
      end
      rows += "\n"
    end

    rows
  end
end