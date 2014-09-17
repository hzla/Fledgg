class AddRaterToAppointments < ActiveRecord::Migration
  def change
    add_column :appointments, :rater, :boolean
  end
end
