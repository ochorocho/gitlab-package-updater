class GitAction

  def initialize(options)
    @options = options
    @repo = Git.open(options[:repo])
    # :log => Logger.new(STDOUT)
    @branch = "update/gitlab-package-updater"
  end

  def create_branch
    @repo.branch(@branch).create
  end

  def checkout
    @repo.checkout(@branch)
  end

  def files_changed
    `cd #{@options[:repo]} git checkout #{@branch} > /dev/null && git status -s | awk '{if ($1 == "M") print $2}'`.split("\n")
  end

  def add
    @repo.add('.')
  end

  def commit
    @repo.commit('Updated Packages')
  end

  def push
    @repo.push('origin', @branch)
  end
end