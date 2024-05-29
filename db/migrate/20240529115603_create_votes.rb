class CreateVotes < ActiveRecord::Migration[7.1]
  def change
    create_table :votes do |t|
      t.string :type
      t.string :type_id
      t.string :user_id
      t.string :action

      t.timestamps
    end
  end
end
