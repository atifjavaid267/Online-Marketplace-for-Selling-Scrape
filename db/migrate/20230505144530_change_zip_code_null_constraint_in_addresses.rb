class ChangeZipCodeNullConstraintInAddresses < ActiveRecord::Migration[6.1]
  def change
    change_column :addresses, :zip_code, :string, null: true
  end
end
