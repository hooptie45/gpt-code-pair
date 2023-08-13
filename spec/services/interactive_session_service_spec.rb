require 'rails_helper'

RSpec.describe InteractiveSessionService, type: :service do
  let(:service) { InteractiveSessionService.new(repository_url) } 
  let(:name) { "MyProject" } 
  let(:project) { service.create_project! }
  let(:repository_url) { 'https://github.com/hooptie45/gpt-pair-test.git' }
  let(:local_path) { Rails.root.join('tmp', 'test_repo') }

  before do
    project.repository_path = Tempfile.new(name)
    project.repository_path
  end
  
  describe '#read_file' do
    it 'reads the content of the specified file' do
      file_path = 'file.txt'
      content = 'File content'
  
      # Write content to the file as part of the test setup
      File.write(File.join(local_path, file_path), content)
  
      # Read the content using the read_file method
      read_content = service.read_file(file_path)
  
      expect(read_content).to eq(content)
    end
  
    it 'returns nil for a non-existent file' do
      file_path = 'non_existent_file.txt'
  
      read_content = service.read_file(file_path)
  
      expect(read_content).to be_nil
    end
  end
  
  describe '#create_project' do
    it 'creates a new project with the given name' do
      expect(project.name).to eq(name)
    end
  end

  describe '#read_file' do
    it 'adds specified file' do
      code = "def my_function; end"
      file_name = "lib/foo.rb"
      service.add_code(file_name, code)

      expect(service.read_file(file_name)).to include(code)
    end
  end

  describe '#add_code' do
    it 'adds code to the specified file' do
      code = "def my_function; end"
      file_name = "lib/foo.rb"
      service.add_code(file_name, code)

      expect(service.read_file(file_name)).to include(code)
    end
  end

  describe '#commit_changes' do
    it 'commits changes with the given message' do
      message = 'Initial commit'

      commit = service.commit_changes(message)

      expect(commit.message).to eq(message)
    end
  end
end
