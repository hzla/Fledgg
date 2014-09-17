class AddUrlToMeetings < ActiveRecord::Migration
  def change
    add_column :meetings, :url, :string
    add_column :meetings, :start_time, :datetime
  end
end
