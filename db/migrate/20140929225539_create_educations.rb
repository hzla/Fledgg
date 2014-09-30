class CreateEducations < ActiveRecord::Migration
  def change
    create_table :educations do |t|
      t.string :name
      t.integer :start_year
      t.integer :end_year
      t.integer :user_id
      t.timestamps
    end
  end
end
