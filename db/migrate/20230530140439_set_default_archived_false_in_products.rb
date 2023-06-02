class SetDefaultArchivedFalseInProducts < ActiveRecord::Migration[6.1]
  def change
    change_column :products, :archived, :boolean, default: false
  end
end
