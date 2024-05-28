class CreateItems < ActiveRecord::Migration[7.1]
  def change
    create_table :items do |t|
      t.string :owner_id
      t.string :collection_id
      t.text :name
      t.string :tag

      t.timestamps
    end
  end
end
