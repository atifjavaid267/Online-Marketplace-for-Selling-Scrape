class SetDefaultArchivedFalseInAds < ActiveRecord::Migration[6.1]
  def change
    change_column :ads, :archived, :boolean, default: false
  end
end
