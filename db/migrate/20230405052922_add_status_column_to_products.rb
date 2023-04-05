class AddStatusColumnToProducts < ActiveRecord::Migration[6.1]
  def change
    add_column :products, :status, :boolean, :default => true
  end
end
