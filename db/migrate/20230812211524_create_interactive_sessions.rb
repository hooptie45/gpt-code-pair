class CreateInteractiveSessions < ActiveRecord::Migration[7.0]
  def change
    create_table :interactive_sessions do |t|

      t.timestamps
    end

  end
end
