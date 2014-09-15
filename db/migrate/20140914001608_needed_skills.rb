class NeededSkills < ActiveRecord::Migration
  def change
  	create_table :needed_skills do |t|
      t.string :name
      t.timestamps
    end
  end
end
