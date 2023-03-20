class AddColumnsToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :phone_no, :string
    add_column :users, :role, :string

    add_index :users, :phone_no,                unique: true
  end
end
