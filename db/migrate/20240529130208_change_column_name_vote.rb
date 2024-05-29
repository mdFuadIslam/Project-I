class ChangeColumnNameVote < ActiveRecord::Migration[7.1]
  def change
    remove_column :votes, :type
    add_column :votes, :type_name, :string
  end
end
