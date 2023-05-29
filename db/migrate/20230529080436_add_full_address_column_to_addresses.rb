class AddFullAddressColumnToAddresses < ActiveRecord::Migration[6.1]
  def change
    add_column :addresses, :full_address, :string
  end
end
