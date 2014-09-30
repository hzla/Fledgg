class CreateExperiences < ActiveRecord::Migration
  def change
    create_table :experiences do |t|
      t.string :company
      t.string :title
      t.boolean :is_current
      t.text :summary
      t.datetime :start_date
      t.datetime :end_date
      t.integer :user_id
      t.timestamps
    end
  end
end
