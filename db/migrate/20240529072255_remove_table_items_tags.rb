class RemoveTableItemsTags < ActiveRecord::Migration[7.1]
  def change
    drop_table :items_tags
  end
end
