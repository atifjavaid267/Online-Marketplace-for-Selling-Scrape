class ChangeDafaultTotalValueInNotifications < ActiveRecord::Migration[6.1]
  def up
    change_column_default :notifications, :total, 0
  end

  def down
    change_column_default :notifications, :total, 1
  end
end
