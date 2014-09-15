class AddTrashedToConversations < ActiveRecord::Migration
  def change
    add_column :conversations, :trashed, :boolean, default: false
  end
end
