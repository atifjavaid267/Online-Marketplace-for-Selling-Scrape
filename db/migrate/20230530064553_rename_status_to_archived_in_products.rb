class RenameStatusToArchivedInProducts < ActiveRecord::Migration[6.1]
  def change
    rename_column :products, :status, :archived
  end
end
