class AddcolumntoComments < ActiveRecord::Migration[7.1]
  def change
    add_column :comments, :user_name, :string
  end
end
