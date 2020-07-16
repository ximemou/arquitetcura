class CreateShipments < ActiveRecord::Migration[5.1]
  def change
    create_table :shipments do |t|
	t.string "origin_latitude"
    t.string "origin_longitude"
    t.string "destination_latitude"
    t.string "destination_longitude"
    t.float "estimated_price"
    t.float "price"
    t.integer "origin_postal_code"
    t.integer "destination_postal_code"
    t.integer "cadet_id"
    t.integer "user_sender_id"
    t.integer "user_receiver_id"
    t.boolean "delivered"
    t.datetime "shipment_solicitude_time"
    t.datetime "shipment_delivery_time"
    t.string "receiver_signature_image"
    t.float "commission"
    t.integer "payed_by"
    t.boolean "applies_discount"
    t.float "package_weight"
    t.string "origin_address"
    t.string "destination_address"
    end
  end
end
