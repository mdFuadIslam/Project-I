class CreateCollections < ActiveRecord::Migration[7.1]
  def change
    create_table :collections do |t|
      t.string :name
      t.text :description
      t.string :category
      t.string :owner_id

      t.timestamps
    end
  end
end
