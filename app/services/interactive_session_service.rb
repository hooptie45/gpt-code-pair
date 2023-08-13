require 'git'
require 'octokit'

class InteractiveSessionService
  attr_reader :project, :files
  
  def initialize(repository_url)
    name = repository_url.split("/")[-1]
    @project = Project.new(name: name)
    dest = Rails.root.join("tmp", "my_app_#{Time.now.to_i}_#{rand(100)}")
    @repo = GitService.new(repository_url, dest)
    @files = {}
  end

  def create_project!
    @project.save!
    
    @project
  end

  def add_code(file_name, code)
    @files[file_name] = code
  end

  def commit_changes(message)
    files.each do |file_name, content|
      @repo.update_file(file_name, content)
    end
  end

  def read_file(file_name)
    @repo.read_file(file_name)
  end
end
