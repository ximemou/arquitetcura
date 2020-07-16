class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
     t.string "name"
	    t.string "lastname"
	    t.string "email"
	    t.string "id_card"
	    t.string "profile_image"
	    t.string "provider"
	    t.string "uid"
      t.timestamps
    end
  end
end
