# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_05_13_170514) do

  create_table "notes", force: :cascade do |t|
    t.text "content"
    t.integer "user_id"
    t.integer "station_id"
    t.boolean "admin", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["station_id"], name: "index_notes_on_station_id"
    t.index ["user_id"], name: "index_notes_on_user_id"
  end

  create_table "stations", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.string "zip"
    t.string "status"
    t.string "access"
    t.boolean "updates", default: false
    t.boolean "flagged", default: false
    t.boolean "NEMA1450", default: false
    t.boolean "NEMA515", default: false
    t.boolean "NEMA520", default: false
    t.boolean "J1772", default: false
    t.boolean "J1772COMBO", default: false
    t.boolean "CHADEMO", default: false
    t.boolean "TESLA", default: false
    t.boolean "BD", default: false
    t.boolean "CNG", default: false
    t.boolean "ELEC", default: false
    t.boolean "E85", default: false
    t.boolean "HY", default: false
    t.boolean "LNG", default: false
    t.boolean "LPG", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "city"
    t.string "state"
    t.integer "api_id"
    t.string "phone", default: "N/A"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.string "zip"
    t.boolean "BD", default: false
    t.boolean "CNG", default: false
    t.boolean "ELEC", default: true
    t.boolean "E85", default: false
    t.boolean "HY", default: false
    t.boolean "LNG", default: false
    t.boolean "LPG", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "uid"
    t.string "provider"
  end

  create_table "users_stations", force: :cascade do |t|
    t.integer "user_id"
    t.integer "station_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "date_visited"
    t.index ["station_id"], name: "index_users_stations_on_station_id"
    t.index ["user_id"], name: "index_users_stations_on_user_id"
  end

end
