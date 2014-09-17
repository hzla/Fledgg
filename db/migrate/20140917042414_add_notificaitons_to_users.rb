class AddNotificaitonsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :notify_messages, :boolean, default: true
    add_column :users, :notify_meetings, :boolean, default: true
  end
end
