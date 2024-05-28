class RemoveColumnFromItem < ActiveRecord::Migration[7.1]
  def change
    remove_column :items, :tag
  end
end
