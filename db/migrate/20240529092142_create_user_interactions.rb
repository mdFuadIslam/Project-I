class CreateUserInteractions < ActiveRecord::Migration[7.1]
  def change
    create_table :user_interactions do |t|
      t.string :type
      t.string :type_id
      t.integer :likes, default: 0
      t.integer :dislikes, default: 0

      t.timestamps
    end
  end
end
