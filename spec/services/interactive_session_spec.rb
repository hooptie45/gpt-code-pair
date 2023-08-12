require 'rails_helper'

RSpec.describe InteractiveSessionService, type: :service do
  describe '#create_project' do
    it 'creates a new project with the given name' do
      service = InteractiveSessionService.new
      project_name = 'MyProject'

      project = service.create_project(project_name)

      expect(project.name).to eq(project_name)
    end
  end

  describe '#add_code' do
    it 'adds code to the specified file' do
      service = InteractiveSessionService.new
      file_name = 'my_file.rb'
      code = "def my_function; end"

      service.add_code(file_name, code)

      expect(service.files[file_name]).to eq(code)
    end
  end

  describe '#commit_changes' do
    it 'commits changes with the given message' do
      service = InteractiveSessionService.new
      project_name = 'MyProject'
      service.create_project(project_name)
      message = 'Initial commit'

      # Assuming Git repository setup and other necessary logic
      commit = service.commit_changes(message)

      expect(commit.message).to eq(message)
    end
  end

  describe '#read_file' do
    it 'reads the content of the specified file' do
      service = InteractiveSessionService.new
      project_name = 'MyProject'
      service.create_project(project_name)
      file_name = 'my_file.rb'
      code = "def my_function; end"
      service.add_code(file_name, code)

      # Assuming file writing and other necessary logic
      content = service.read_file(file_name)

      expect(content).to eq(code)
    end
  end
end
