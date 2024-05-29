class CreateTags < ActiveRecord::Migration[7.1]
  def change
    create_table :tags do |t|
      t.text :name
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
      t.integer :count, default: 1

      t.timestamps
    end
  end
end
