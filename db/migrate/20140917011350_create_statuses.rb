class CreateStatuses < ActiveRecord::Migration
  def change
    create_table :statuses do |t|
      t.text :body
      t.integer :like_count, default: 0
      t.integer :user_id
      t.integer :comment_count, default: 0
      t.timestamps
    end
  end
end
