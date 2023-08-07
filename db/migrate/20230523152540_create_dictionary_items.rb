class CreateDictionaryItems < ActiveRecord::Migration[7.0]
  def change
    create_table :dictionary_items do |t|
      t.string :name
      t.references :dictionary

      t.timestamps
    end
  end
end
