class ChangeHelpfulnessInUsers < ActiveRecord::Migration
  def change
  	change_column :users, :helpfulness, :float
  end
end
