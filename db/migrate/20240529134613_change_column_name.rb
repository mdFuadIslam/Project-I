class ChangeColumnName < ActiveRecord::Migration[7.1]
  def change
    remove_column :comments, :type
    add_column :comments, :type_name, :string
  end
end
