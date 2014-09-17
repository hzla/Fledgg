class AddDismissedToAppointments < ActiveRecord::Migration
  def change
    add_column :appointments, :dismissed, :boolean
  end
end
