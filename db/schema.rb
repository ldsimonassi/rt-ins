# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160628034829) do

  create_table "addresses", force: :cascade do |t|
    t.integer "user_id",    null: false
    t.integer "city_id",    null: false
    t.string  "name",       null: false
    t.string  "street",     null: false
    t.integer "number",     null: false
    t.string  "directions"
    t.string  "zip_code",   null: false
  end

  add_index "addresses", ["user_id", "name"], name: "index_addresses_on_user_id_and_name", unique: true

  create_table "brands", force: :cascade do |t|
    t.integer  "country_id", null: false
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "brands", ["country_id", "name"], name: "index_brands_by_country_id_and_name", unique: true
  add_index "brands", ["country_id"], name: "index_brands_on_country_id"

  create_table "cities", force: :cascade do |t|
    t.string   "name",        null: false
    t.integer  "province_id", null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "cities", ["province_id", "name"], name: "index_cities_on_province_id_and_name", unique: true

  create_table "countries", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "countries", ["name"], name: "index_countries_on_name", unique: true

  create_table "device_locations", force: :cascade do |t|
    t.integer  "tracking_device_id"
    t.string   "period"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "driver_id",          default: 0, null: false
  end

  add_index "device_locations", ["driver_id", "period", "tracking_device_id"], name: "index_device_locations_by_driver_id_period_and_trk"
  add_index "device_locations", ["tracking_device_id", "period"], name: "index_device_locations_on_tracking_device_id_and_period"

  create_table "device_models", force: :cascade do |t|
    t.string   "gps",           null: false
    t.string   "obdi",          null: false
    t.string   "accelerometer", null: false
    t.string   "camera",        null: false
    t.string   "computer",      null: false
    t.string   "name",          null: false
    t.string   "manufacturer",  null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "device_tracks", force: :cascade do |t|
    t.integer  "tracking_device_id",                null: false
    t.string   "period",                            null: false
    t.integer  "speed_max",                         null: false
    t.integer  "speed_p75",                         null: false
    t.integer  "speed_avg",                         null: false
    t.integer  "speed_p25",                         null: false
    t.integer  "speed_min",                         null: false
    t.float    "acceleration_up",                   null: false
    t.float    "acceleration_down",                 null: false
    t.float    "acceleration_forward",              null: false
    t.float    "acceleration_backward",             null: false
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.integer  "driver_id",             default: 0, null: false
  end

  add_index "device_tracks", ["driver_id", "period", "tracking_device_id"], name: "index_device_tracks_by_driver_id_tracking_device_id_and_period"
  add_index "device_tracks", ["tracking_device_id", "period"], name: "index_device_tracks_on_tracking_device_id_and_period"

  create_table "drivers", force: :cascade do |t|
    t.string   "name",                      null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "user_id"
    t.string   "passphrase"
    t.string   "internal_id", default: "1", null: false
  end

  add_index "drivers", ["user_id", "id"], name: "index_drivers_by_user_id_and_id"
  add_index "drivers", ["user_id", "internal_id"], name: "index_drivers_by_user_id_and_internal_id", unique: true
  add_index "drivers", ["user_id", "name"], name: "index_drivers_by_user_id_and_name", unique: true

  create_table "models", force: :cascade do |t|
    t.string   "name"
    t.integer  "brand_id",   null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "models", ["brand_id", "name"], name: "index_models_by_brand_id_and_name", unique: true
  add_index "models", ["brand_id"], name: "index_models_on_brand_id"

  create_table "prices", force: :cascade do |t|
    t.integer  "version_id", null: false
    t.integer  "year",       null: false
    t.string   "currency",   null: false
    t.integer  "price",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "prices", ["version_id", "year", "currency"], name: "index_prices_by_version_id_year_and_currency"
  add_index "prices", ["version_id"], name: "index_prices_on_version_id"

  create_table "provinces", force: :cascade do |t|
    t.integer  "country_id", null: false
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "provinces", ["country_id", "name"], name: "index_provinces_on_country_id_and_name", unique: true

  create_table "tracking_devices", force: :cascade do |t|
    t.string   "serial_no",       null: false
    t.integer  "device_model_id", null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "tracking_devices", ["device_model_id"], name: "index_tracking_devices_on_device_model_id"
  add_index "tracking_devices", ["serial_no"], name: "index_tracking_devices_on_serial_no", unique: true

  create_table "users", force: :cascade do |t|
    t.integer  "country_id",      null: false
    t.string   "username",        null: false
    t.string   "email",           null: false
    t.string   "first_name",      null: false
    t.string   "last_name",       null: false
    t.string   "password_digest", null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["username"], name: "index_users_on_username", unique: true

  create_table "vehicles", force: :cascade do |t|
    t.string   "name",               null: false
    t.integer  "price_id",           null: false
    t.integer  "user_id",            null: false
    t.integer  "country_id",         null: false
    t.integer  "tracking_device_id", null: false
    t.string   "chasis_no",          null: false
    t.string   "engine_no",          null: false
    t.string   "plate_no",           null: false
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "vehicles", ["country_id", "chasis_no"], name: "index_vehicles_on_country_id_and_chasis_no", unique: true
  add_index "vehicles", ["country_id", "engine_no"], name: "index_vehicles_on_country_id_and_engine_no", unique: true
  add_index "vehicles", ["country_id", "plate_no"], name: "index_vehicles_on_country_id_and_plate_no", unique: true
  add_index "vehicles", ["tracking_device_id"], name: "index_vehicles_on_tracking_device_id", unique: true
  add_index "vehicles", ["user_id"], name: "index_vehicles_on_user_id"

  create_table "versions", force: :cascade do |t|
    t.string   "name",       null: false
    t.integer  "model_id",   null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "versions", ["model_id", "name"], name: "index_versions_by_model_id_and_name", unique: true
  add_index "versions", ["model_id"], name: "index_versions_on_model_id"

end
