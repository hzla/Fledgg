class CreateConnections < ActiveRecord::Migration
  def change
    create_table :connections do |t|
      t.integer :conversation_id
      t.integer :user_id
      t.timestamps
    end
  end
end
