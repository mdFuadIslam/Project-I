class AddToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :name, :string
    add_column :users, :status, :string, default: 'member'
    add_column :users, :theme, :string, default: 'dark'
    add_column :users, :language, :string, default: 'en'
    add_column :users, :nationality, :string, default: ''
    add_column :users, :city, :string, default: ''
  end
end
