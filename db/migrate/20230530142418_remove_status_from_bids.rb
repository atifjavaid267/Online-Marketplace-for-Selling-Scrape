class RemoveStatusFromBids < ActiveRecord::Migration[6.1]
  def change
    remove_column :bids, :status, :string
  end
end
