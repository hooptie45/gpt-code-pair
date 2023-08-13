require 'git'
require 'octokit' # For interacting with the GitHub API

class GitService

  MAINLINE = "main"

  attr_reader :repository_url, :local_path

  def current_branch_master?
    with_repo do |repo|
      repo.current_branch == MAINLINE
    end
    
  end

  def create_and_switch_branch(branch_name)
    git.branch(branch_name).checkout
  end

  def initialize(repository_url, local_path)
    @repository_url = repository_url
    @local_path = Pathname(local_path)
    local_path.mkpath
  end

  def git
    clone_repository
  end

  def clone_repository
    return @git if defined?(@git) && repository_cloned? 
    if repository_cloned?  
      _git = Git.open(local_path)
      
      unless _git.remote.url == repository_url
        raise "Remote URL mismatch: expected #{repository_url}, got #{_git.remote.url}" 
        git.remote
      end

    else
      _git = Git.clone(repository_url, local_path)
    end
    @git = _git
    git
  end

  def with_repo
    clone_repository
    yield(@git)
  end

  def update_files(files, branch_name = 'feature-branch')
    with_repo do |repo|
      create_and_switch_branch(branch_name)
      files.each do |file_name, content|
        File.write(File.join(local_path, file_name), content)
        repo.add(file_name)
      end  
    end
    
  end
  
  def update_file(file_name, content)
    with_repo do |repo|
      begin
        File.write(local_path.join(file_name), content)
        repo.add(file_name)  
      rescue => exception
        binding.pry
      end   
    end
    
  end
  
  def read_file(file_path)
    full_path = File.join(local_path, file_path)
    File.read(full_path) if File.exist?(full_path)
  end

  def commit_changes(message)
    with_repo do |repo|
      repo.commit(message)
      repo.log.first
    end
  end

  def push_changes(branch = MAINLINE)
    git.push('origin', branch)
  end

  def create_pull_request(title, body, base_branch = MAINLINE, head_branch = MAINLINE)
    client = Octokit::Client.new(access_token: ENV['GITHUB_ACCESS_TOKEN'])
    repo = repository_url.split('/').last(2).join('/').gsub('.git', '')
    client.create_pull_request(repo, base_branch, head_branch, title, body)
  end

  private

  def repository_cloned?
    local_path.join(".git").exist?
  end

  def verify_remote_url
    remote_url = @git.remote.url
    raise "Remote URL mismatch: expected #{repository_url}, got #{remote_url}" unless remote_url == repository_url
  end
end
