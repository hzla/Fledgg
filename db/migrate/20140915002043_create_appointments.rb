class CreateAppointments < ActiveRecord::Migration
  def change
    create_table :appointments do |t|
      t.integer :meeting_id
      t.integer :user_id
      t.boolean :accepted
      t.boolean :declined
    end

    add_index :appointments, [:user_id, :meeting_id]
    add_index :connections, [:user_id, :conversation_id]
  end
end
