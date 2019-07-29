class GeneralUpdater

  def initialize(options)
    Gitlab.configure do |config|
      config.endpoint = options[:url] + '/api/v4'
      config.private_token = options[:token]
      config.user_agent = 'Gitlab Package Updater'
    end

    @options = options
    @project = Gitlab.project(options[:project]).to_yaml
    @repo = Git.open(options[:repo], :log => Logger.new(STDOUT))
  end

  def self.create_branch
    @repo.branch("update/gitlab-package-updater").create
    @repo.branch("update/gitlab-package-updater").checkout
  end

  def self.commit
    @repo.add('.')
    @repo.commit('Updated Packages', '')
  end

  def push
    @repo.push('origin', 'update/gitlab-package-updater')
  end

  def create_merge_request
    description = ":bomb: **Fancy ey?**"
    Gitlab.create_merge_request(52, "Packages updated", source_branch: 'update/gitlab-package-updater', target_branch: 'master', description: description)
  end

  def update_merge_request
    description = ":bomb: **Fancy ey?**"
    Gitlab.create_merge_request(52, "Packages updated", source_branch: 'update/gitlab-package-updater', target_branch: 'master', description: description)
  end

  def headline(keys)
    '| ' + keys.join(' | ') + " |\n"
  end

  def headline_seperator(keys)
    headline = '| '
    keys.each do |field|
      separate = "----------------------------------------------------".slice(1..field.length)
      headline += "#{separate} | "
    end
    headline += "\n"
  end
end