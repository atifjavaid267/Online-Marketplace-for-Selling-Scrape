class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
      t.integer  :bid_id, null: false
      t.datetime :pickup_time
      t.string :status, default: "pending"
      t.timestamps
    end
  end
end
