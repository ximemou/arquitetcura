# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20171122142419) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "records", force: :cascade do |t|
    t.json "area"
    t.string "kgCost"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "shipments", force: :cascade do |t|
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
