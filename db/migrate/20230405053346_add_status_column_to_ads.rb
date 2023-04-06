class AddStatusColumnToAds < ActiveRecord::Migration[6.1]
  def change
    add_column :ads, :status, :boolean, :default => true
  end
end
