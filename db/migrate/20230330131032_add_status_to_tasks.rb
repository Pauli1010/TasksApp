class AddStatusToTasks < ActiveRecord::Migration[7.0]
  def change
    add_column :tasks, :status, :string, default: 'added'
  end
end
