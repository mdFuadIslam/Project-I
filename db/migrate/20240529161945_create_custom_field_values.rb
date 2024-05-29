class CreateCustomFieldValues < ActiveRecord::Migration[7.1]
  def change
    create_table :custom_field_values do |t|
      t.string :item_id
      t.string :field_id
      t.string :value

      t.timestamps
    end
  end
end
