class ChangeSenderAndReceiverDataTypesInNotifications < ActiveRecord::Migration[6.1]
    def change
      change_column :notifications, :sender, 'integer USING CAST(sender AS integer)'
      change_column :notifications, :receiver, 'integer USING CAST(receiver AS integer)'
    end
end
