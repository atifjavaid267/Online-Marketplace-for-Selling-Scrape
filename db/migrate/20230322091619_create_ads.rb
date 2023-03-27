class CreateAds < ActiveRecord::Migration[6.1]
  def change
    create_table :ads do |t|
      t.integer :user_id, :null => false
      t.integer :product_id, :null => false
      t.decimal :price, precision: 12, scale: 2
      t.integer :address_id, :null => false
      t.timestamps
    end
  end
end
