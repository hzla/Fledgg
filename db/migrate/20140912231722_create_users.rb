class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
    	t.string :name
      t.string :location
      t.string :tagline
      t.integer :helpfulness, default: 3
    	t.string :email
      t.string :interests
      t.string :profile_pic_url
      t.string :li_token
      t.string :birthday
      t.string :star_sign
      t.string :personality
      t.string :favorite_book
      t.string :favorite_movie
  		t.string :mon
  		t.string :tues
  		t.string :wed
  		t.string :thurs
  		t.string :fri
  		t.string :sat
  		t.string :sun
    	t.text :bio
    	t.text :info
    	t.timestamps
    end
  end
end
