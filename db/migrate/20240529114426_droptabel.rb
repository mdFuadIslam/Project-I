class Droptabel < ActiveRecord::Migration[7.1]
  def change
    drop_table :user_interactions
  end
end
