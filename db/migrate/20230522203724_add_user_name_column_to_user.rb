class AddUserNameColumnToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :user_name, :string, after: :email
  end
end
