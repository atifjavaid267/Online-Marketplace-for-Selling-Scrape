class CreateBids < ActiveRecord::Migration[6.1]
  def change
    create_table :bids do |t|
      t.integer :ad_id, :null => false
      t.integer :user_id, :null => false
      t.decimal :price, precision: 12, scale: 2, :null => false
      t.timestamps
    end
  end
end
