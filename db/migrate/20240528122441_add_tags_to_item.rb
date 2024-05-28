class AddTagsToItem < ActiveRecord::Migration[7.1]
  def change
    add_column :items, :tag, :text, default: 'all'
  end
end
