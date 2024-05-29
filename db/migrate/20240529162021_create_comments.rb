class CreateComments < ActiveRecord::Migration[7.1]
  def change
    create_table :comments do |t|
      t.string :type_id
      t.text :content
      t.string :user_id
      t.string :user_name
      t.string :type_name

      t.timestamps
    end
  end
end
