class AddPastToMeetings < ActiveRecord::Migration
  def change
    add_column :meetings, :past, :boolean, default: false
  end
end
