require 'rails_helper'
RSpec.describe Project, type: :model do 
  describe '#execute_command' do
    let(:project) { Project.create(name: 'MyProject', repository_path: '/path/to/repo') }
  
    it 'updates the name when given the "update_name" command' do
      command = 'update_name NewProjectName'
  
      project.execute_command(command)
  
      expect(project.name).to eq('NewProjectName')
    end
  
    it 'updates the repository path when given the "update_repository_path" command' do
      command = 'update_repository_path /new/path/to/repo'
  
      project.execute_command(command)
  
      expect(project.repository_path).to eq('/new/path/to/repo')
    end
  
    it 'returns an error for an unknown command' do
      command = 'unknown_command'
  
      expect { project.execute_command(command) }.to raise_error('Unknown command')
    end
  end
  
end