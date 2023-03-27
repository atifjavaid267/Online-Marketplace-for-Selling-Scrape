class CreateAddresses < ActiveRecord::Migration[6.1]
  def change
    create_table :addresses do |t|
      t.integer :user_id, :null => false
      t.string :street1, default: ""
      t.string :street2, default: ""
      t.string :city, :null => false
      t.string :state, :null => false
      t.string :zip_code, :null => false

      t.decimal :latitude, :precision => 10, :scale => 6, :null => false
      t.decimal :longitude, :precision => 10, :scale => 6, :null => false

      t.timestamps
    end
  end
end
