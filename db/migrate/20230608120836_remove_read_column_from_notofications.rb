class RemoveReadColumnFromNotofications < ActiveRecord::Migration[6.1]
  def change
    remove_column :notifications, :read, :boolean
  end
end
