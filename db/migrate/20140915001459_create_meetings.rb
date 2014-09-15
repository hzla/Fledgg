class CreateMeetings < ActiveRecord::Migration
  def change
    create_table :meetings do |t|
      t.string :name
      t.string :title
      t.integer :creator
      t.integer :receiver
      t.timestamps
    end
  end
end
