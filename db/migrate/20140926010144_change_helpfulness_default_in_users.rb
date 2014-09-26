class ChangeHelpfulnessDefaultInUsers < ActiveRecord::Migration
  def change
  	change_column :users, :helpfulness, :float, default: 3.0
  end
end
