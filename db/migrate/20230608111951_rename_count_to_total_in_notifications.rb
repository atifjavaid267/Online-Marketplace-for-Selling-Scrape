class RenameCountToTotalInNotifications < ActiveRecord::Migration[6.1]
  def change
    rename_column :notifications, :count, :total
  end
end
