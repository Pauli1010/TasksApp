class AdditionalFieldsForUsers < ActiveRecord::Migration[7.0]
  def change
    change_table :users do |t|
      t.column :first_name, :string
      t.column :last_name, :string
      t.column :admin, :boolean, default: false
    end
  end
end
