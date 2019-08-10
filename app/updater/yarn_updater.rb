require_relative 'general_updater'

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
    rows = row(json_data["data"]["body"])

    if rows == ''
      table = "\n### Yarn\n\n"
      table += headline(json_data["data"]["head"])
      table += headline_seperator(json_data["data"]["head"])
      table += rows

      table
    end
  end

  def row(json)
    rows = ''

    json.each do |package|
      unless package[1] == package[2]
        rows += '| '
        package.each do |field|
          rows += "#{field} | "
        end
        rows += "\n"
      end
    end

    rows
  end
end