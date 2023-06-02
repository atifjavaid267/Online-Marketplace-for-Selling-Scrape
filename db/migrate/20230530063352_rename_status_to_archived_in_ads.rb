class RenameStatusToArchivedInAds < ActiveRecord::Migration[6.1]
  def change
    rename_column :ads, :status, :archived
  end
end
