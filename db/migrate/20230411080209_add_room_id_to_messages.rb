class AddRoomIdToMessages < ActiveRecord::Migration[6.1]
  def change
    add_column :messages, :room_id, :integer
  end
end
