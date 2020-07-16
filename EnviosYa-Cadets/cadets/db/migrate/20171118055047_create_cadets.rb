class CreateCadets < ActiveRecord::Migration[5.1]
  def change
    create_table :cadets do |t|
	t.string "name"
    t.string "lastname"
    t.string "email"
    t.string "id_card"
    t.string "profile_image"
    t.string "driver_license_image"
    t.string "vehicle_information"
    t.string "password"
    t.boolean "pending"
    t.string "latitude", default: "-34.903205"
    t.string "longitude", default: "-56.194258"
      t.timestamps
    end
  end
end
