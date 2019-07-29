require './src/general_updater'

class YarnUpdater < GeneralUpdater
  OUTPUT_FORMAT = "--json".freeze

  def install
    system("yarn install --cwd #{@options[:repo]}")
  end

  def outdated
    packages = `yarn outdated #{OUTPUT_FORMAT} --cwd #{@options[:repo]}`
    parse_to_markdown(packages)
  end

  def update
    `yarn upgrade --cwd #{@options[:repo]}`
  end

  private

  def parse_to_markdown(json)
    json = json.split("\n")
    json_data = JSON.parse(json[1])

    table = "\n### Yarn\n\n"
    table += headline(json_data["data"]["head"])
    table += headline_seperator(json_data["data"]["head"])
    table += row(json_data["data"]["body"])

    puts table
  end

  def row(json)
    rows = ''
    json.each do |package|
      rows += '| '
      package.each do |field|
        rows += "#{field} | "
      end
      rows += "\n"
    end

    rows
  end
end