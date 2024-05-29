class CreateComments < ActiveRecord::Migration[7.1]
  def change
    create_table :comments do |t|
      t.string :type
      t.string :type_id
      t.text :content
      t.string :user_id

      t.timestamps
    end
  end
end
