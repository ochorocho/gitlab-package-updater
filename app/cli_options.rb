class CliOptions

  def self.get
    # This will hold the options we parse
    options = {
      repo: './'
    }

    OptionParser.new do |parser|
      parser.on('-v', '--version', 'Current version.') do
        puts '1.0.0'
        options[:version] = '1.0.0'
      end

      parser.on('-r', '--repo PATH', 'Path to git Repository') do |v|
        options[:repo] = v
      end

      parser.on('-p', '--project ID', 'Gitlab project id') do |v|
        options[:project] = v
      end

      parser.on('-u', '--url URl', 'Gitlab instance url') do |v|
        options[:url] = v
      end

      parser.on('-t', '--private-token TOKEN', 'Gitlab user private token') do |v|
        options[:token] = v
      end
    end.parse!

    options
  end
end