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

ActiveRecord::Schema.define(version: 20160529135123) do

  create_table "addresses", force: :cascade do |t|
    t.integer "user_id"
    t.integer "city_id"
    t.string  "name"
    t.string  "street"
    t.integer "number"
    t.string  "directions"
    t.string  "zip_code"
  end

  add_index "addresses", ["user_id", "name"], name: "index_addresses_on_user_id_and_name", unique: true

  create_table "brands", force: :cascade do |t|
    t.integer  "country_id"
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "brands", ["country_id", "name"], name: "index_brands_by_country_id_and_name", unique: true
  add_index "brands", ["country_id"], name: "index_brands_on_country_id"

  create_table "cities", force: :cascade do |t|
    t.string   "name"
    t.integer  "province_id"
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

  create_table "models", force: :cascade do |t|
    t.string   "name"
    t.integer  "brand_id"
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
    t.integer  "country_id"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "provinces", ["country_id", "name"], name: "index_provinces_on_country_id_and_name", unique: true

  create_table "users", force: :cascade do |t|
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
    t.string   "name",       null: false
    t.integer  "price_id",   null: false
    t.integer  "user_id",    null: false
    t.integer  "country_id", null: false
    t.string   "chasis_no",  null: false
    t.string   "engine_no",  null: false
    t.string   "plate_no",   null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "vehicles", ["country_id", "chasis_no"], name: "index_vehicles_on_country_id_and_chasis_no", unique: true
  add_index "vehicles", ["country_id", "engine_no"], name: "index_vehicles_on_country_id_and_engine_no", unique: true
  add_index "vehicles", ["country_id", "plate_no"], name: "index_vehicles_on_country_id_and_plate_no", unique: true
  add_index "vehicles", ["user_id"], name: "index_vehicles_on_user_id"

  create_table "versions", force: :cascade do |t|
    t.string   "name",       null: false
    t.integer  "model_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "versions", ["model_id", "name"], name: "index_versions_by_model_id_and_name", unique: true
  add_index "versions", ["model_id"], name: "index_versions_on_model_id"

end
