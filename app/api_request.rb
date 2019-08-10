class ApiRequest

  def initialize(options, description)
    Gitlab.configure do |config|
      config.endpoint = options[:url]
      config.private_token = options[:token]
      config.user_agent = 'Gitlab Package Updater'
    end

    @options = options
    @project = Gitlab.project(options[:project])
    @repo = Git.open(options[:repo], :log => Logger.new(STDOUT))
    @description = description
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

  def merge_request
    merge_request = Gitlab.merge_requests(@options[:project], { state: "opened", target_branch: @project.default_branch, source_branch: 'update/gitlab-package-updater'})

    if merge_request.count < 1
      create_merge_request
    else
      update_merge_request(merge_request.first.iid)
    end
  end

  private

  def create_merge_request
    Gitlab.create_merge_request(@options[:project], "Packages updated", source_branch: 'update/gitlab-package-updater', target_branch: @project.default_branch, description: @description)
  end

  def update_merge_request(iid)
    Gitlab.update_merge_request(@project.id, iid, { description: @description })
  end
end