class CreateConversations < ActiveRecord::Migration
  def change
    create_table :conversations do |t|
      t.string :name
      t.string :title
      t.integer :creator
      t.integer :meeting_id
      t.timestamps
    end
  end
end
