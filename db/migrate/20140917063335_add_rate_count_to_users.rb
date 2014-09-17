class AddRateCountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :rate_count, :integer, default: 1
  end
end
