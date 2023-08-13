require 'rails_helper'

RSpec.fdescribe GitService, type: :service do
  let(:repository_url) { 'https://github.com/hooptie45/gpt-pair-test.git' }
  let(:local_path) { Rails.root.join('tmp', "test_#{Time.now.to_i}") }
  let(:service) { GitService.new(repository_url, local_path) }

  # before do
  #   FileUtils.mkdir_p(local_path)
  # end

  after do
    FileUtils.rm_rf(local_path)
  end

  describe '#current_branch_master?' do
    it 'returns true if the current branch is master' do
      service.git.branch('master').checkout
  
      expect(service.current_branch_master?).to be_truthy
    end
  
    it 'returns false if the current branch is not master' do
      service.git.branch('feature-branch').checkout
  
      expect(service.current_branch_master?).to be_falsey
    end
  end
  
  describe '#clone_repository' do
    it 'clones the repository to the local path' do
      service.clone_repository

      # Assuming Git repository setup and other necessary logic
      expect(Dir.exist?(local_path)).to be_truthy
    end

    it 'clones the repository to the local path if not already cloned' do
      service.clone_repository
  
      expect(Dir.exist?(File.join(local_path, '.git'))).to be_truthy
    end
  
    it 'does not re-clone the repository if already cloned' do
      # Simulate an existing repository by creating the .git directory
      FileUtils.mkdir_p(File.join(local_path, '.git'))
  
      # Attempt to clone the repository again
      expect(Git).not_to receive(:clone)
      service.clone_repository
    end
  end
  
  
  describe '#update_file' do
    it 'updates the specified file with the given content' do
      file_name = 'file.txt'
      content = "#{Time.now.to_i}"

      service.update_file(file_name, content)

      # Assuming file writing and other necessary logic
      expect(File.read(File.join(local_path, file_name))).to eq(content)
    end
  end

  describe '#update_files' do
    it 'creates and switches to a new branch before updating multiple files' do
      files = {
        'file1.txt' => 'Content 1',
        'file2.txt' => 'Content 2'
      }
      branch_name = 'feature-branch'
  
      service.update_files(files, branch_name)
  
      # Verify that the current branch is the new branch
      expect(service.git.current_branch).to eq(branch_name)
  
      # Verify that the files are updated as expected
      files.each do |file_name, content|
        expect(File.read(File.join(local_path, file_name))).to eq(content)
      end
    end
  end
    
  describe '#commit_changes' do
    it 'commits changes with the given message' do
      file_name = 'file.txt'
      content = "#{Time.now.to_i}"
      service.update_file(file_name, content)

      message = 'Update file'

      # Assuming Git repository setup and other necessary logic
      commit = service.commit_changes(message)

      expect(commit.message).to eq(message)
    end
  end

  describe '#push_changes' do
    it 'pushes changes to the remote repository' do
      # Assuming Git repository setup and other necessary logic
      expect(service.push_changes).to be_truthy
    end
  end

  describe '#create_pull_request' do
    it 'creates a pull request on GitHub' do
      title = 'New Pull Request'
      body = 'Description of the pull request'

      # Assuming GitHub API interaction and other necessary logic
      pr = service.create_pull_request(title, body)

      expect(pr.title).to eq(title)
      expect(pr.body).to eq(body)
    end
  end
end
