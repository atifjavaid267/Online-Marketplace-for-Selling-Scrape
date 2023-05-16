class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.string :sender
      t.string :receiver
      t.boolean :read

      t.timestamps
    end
  end
end
