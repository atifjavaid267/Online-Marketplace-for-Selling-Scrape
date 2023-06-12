class AddOrderIdToNotifications < ActiveRecord::Migration[6.1]
  def change
    add_column :notifications, :order_id, :integer, null: false
  end
end
