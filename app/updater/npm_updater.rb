require_relative 'general_updater'

class NpmUpdater < GeneralUpdater
  OUTPUT_FORMAT = "--json".freeze

  def install
    system("npm install --prefix #{@options[:repo]}")
  end

  def outdated
    packages = `npm outdated #{OUTPUT_FORMAT} --prefix #{@options[:repo]}`
    parse_to_markdown(packages)
  end

  def update
    `npm upgrade --prefix #{@options[:repo]}`
  end

  private

  def parse_to_markdown(json)
    json_data = JSON.parse(json)
    keys = json_data.first[1].keys

    table = "\n### NPM\n\n"
    table += '| name ' + headline(keys)
    table += '| ---- ' + headline_seperator(keys)
    table += row(json_data)

    puts table
  end

  def row(json)
    rows = ''
    json.each do |package|
      rows += "| #{package[0]} | "
      package[1].each do |field|
        rows += "#{field[1]} | "
      end
      rows += "\n"
    end

    rows
  end
end