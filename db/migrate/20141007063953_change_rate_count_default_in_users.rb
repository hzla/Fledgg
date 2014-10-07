class ChangeRateCountDefaultInUsers < ActiveRecord::Migration
  def change
  	change_column :users, :helpfulness, :float, default: 0.0
  	change_column :users, :rate_count, :integer, default: 0 
  end
end
