class AddCountersToUsers < ActiveRecord::Migration
  def change
    add_column :users, :message_count, :integer, default: 0
    add_column :users, :meeting_count, :integer, default: 0
  end
end
