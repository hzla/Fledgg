class AddFollowListToUsers < ActiveRecord::Migration
  def change
    add_column :users, :follow_list, :text, default: ""
  end
end
