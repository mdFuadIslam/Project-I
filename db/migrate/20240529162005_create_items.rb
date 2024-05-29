class CreateItems < ActiveRecord::Migration[7.1]
  def change
    create_table :items do |t|
      t.string :owner_id
      t.string :collection_id
      t.text :name
      t.text :tags, default: "all"
      t.text :image_url

      t.timestamps
    end
  end
end
