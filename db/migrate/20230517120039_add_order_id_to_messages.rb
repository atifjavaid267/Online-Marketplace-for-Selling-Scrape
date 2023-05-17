class AddOrderIdToMessages < ActiveRecord::Migration[6.1]
  def change
    add_reference :messages, :order, foreign_key: true
  end
end
