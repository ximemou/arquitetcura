class CreateDiscounts < ActiveRecord::Migration[5.1]
  def change
    create_table :discounts do |t|
   	t.string "discount_sender_email"
    t.string "discount_receiver_email"
    t.boolean "receiver_made_shipment"
      t.timestamps
    end
  end
end
