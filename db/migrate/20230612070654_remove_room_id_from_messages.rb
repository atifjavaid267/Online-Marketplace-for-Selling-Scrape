class RemoveRoomIdFromMessages < ActiveRecord::Migration[6.1]
  def change
    remove_column :messages, :room_id, :integer
  end
end
