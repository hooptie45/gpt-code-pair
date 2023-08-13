class Project < ApplicationRecord
  validates :name, presence: true
  validates :repository_path, presence: true
  
  def execute_command(command)
    parts = command.split(' ')
    case parts[0]
    when 'update_name'
      update(name: parts[1..-1].join(' '))
    when 'update_repository_path'
      update(repository_path: parts[1..-1].join(' '))
    else
      raise 'Unknown command'
    end
  end
end
