class AddColumntoCollection < ActiveRecord::Migration[7.1]
  def change
    add_column :collections, :items_count, :int, default: 0
  end
end
