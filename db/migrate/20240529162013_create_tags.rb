class CreateTags < ActiveRecord::Migration[7.1]
  def change
    create_table :tags do |t|
      t.text :name
      t.integer :count, default: 1

      t.timestamps
    end
  end
end
