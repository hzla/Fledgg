class CreateExpertises < ActiveRecord::Migration
  def change
    create_table :expertises do |t|
      t.integer :user_id
      t.integer :skill_id
    end

    add_index :expertises, [:user_id, :skill_id]
  end
end
