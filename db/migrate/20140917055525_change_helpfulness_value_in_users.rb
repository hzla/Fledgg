class ChangeHelpfulnessValueInUsers < ActiveRecord::Migration
  def change
  	change_column :users, :helpfulness, :float, default: 5.0
  end
end
