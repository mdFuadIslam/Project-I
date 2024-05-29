class CreateVotes < ActiveRecord::Migration[7.1]
  def change
    create_table :votes do |t|
      t.string :type_id
      t.string :user_id
      t.string :action
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
      t.string :type_name

      t.timestamps
    end
  end
end
