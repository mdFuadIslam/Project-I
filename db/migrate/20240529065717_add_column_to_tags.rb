class AddColumnToTags < ActiveRecord::Migration[7.1]
  def change
    add_column :tags, :count, :integer, default: 1
  end
end
