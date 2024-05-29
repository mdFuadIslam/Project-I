class AddColumnsToTables < ActiveRecord::Migration[7.1]
  def change
    add_column :items, :image_url, :text, default: nil
    add_column :collections, :image_url, :text, default: nil
    add_column :users, :image_url, :text, default: nil
  end
end
