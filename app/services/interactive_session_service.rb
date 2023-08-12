class InteractiveSessionService
  attr_reader :project, :files

  def initialize
    @project = nil
    @files = {}
  end

  def create_project(name)
    @project = Project.new(name: name)
    @project.save!
    @project
  end

  def add_code(file_name, code)
    @files[file_name] = code
  end

  def commit_changes(message)
    # Assuming a Git repository is initialized and set up
    git = Git.open(project.repository_path)
    files.each do |file_name, content|
      File.write(File.join(project.repository_path, file_name), content)
      git.add(file_name)
    end
    git.commit(message)
    git.log.first
  end

  def read_file(file_name)
    File.read(File.join(project.repository_path, file_name))
  end
end
