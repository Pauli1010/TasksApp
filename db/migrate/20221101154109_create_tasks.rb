class CreateTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :tasks do |t|
      t.references :user
      t.string :title
      t.datetime :due_time
      t.datetime :done_time
      t.text :note
      t.boolean :highlited, default: false

      t.timestamps
    end
  end
end
