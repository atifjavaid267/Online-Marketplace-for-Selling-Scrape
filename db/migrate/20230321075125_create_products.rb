class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products do |t|
      t.integer :user_id, :null => false
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
