class AddDefaultValuesToNotifications < ActiveRecord::Migration[6.1]
  def change

    add_column :notifications, :count, :integer, default: 1
    add_column :notifications, :read, :boolean, default: false
  end
end
