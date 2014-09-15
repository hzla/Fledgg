class Wants < ActiveRecord::Migration
  def change
  	create_table :wants do |t|
      t.integer :user_id
      t.integer :needed_skill_id
    end

    add_index :wants, [:user_id, :needed_skill_id]
  end
end
