class AddColumnToBids < ActiveRecord::Migration[6.1]
  def change
    add_column :bids, :status, :string, :default => "pending"
  end
end
