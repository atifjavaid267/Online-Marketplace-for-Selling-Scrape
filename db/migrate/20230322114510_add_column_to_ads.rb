class AddColumnToAds < ActiveRecord::Migration[6.1]
  def change
    add_column :ads, :description, :text
  end
end
