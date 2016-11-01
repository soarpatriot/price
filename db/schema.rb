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

ActiveRecord::Schema.define(version: 20161021064431) do

  create_table "admins", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
  end

  add_index "admins", ["email"], name: "index_admins_on_email", unique: true, using: :btree
  add_index "admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true, using: :btree

  create_table "areas", force: true do |t|
    t.integer  "station_id"
    t.string   "label"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "commission_id"
    t.string   "code"
    t.decimal  "latitude",      precision: 15, scale: 10
    t.decimal  "longitude",     precision: 15, scale: 10
    t.integer  "distance"
    t.decimal  "mian",          precision: 20, scale: 5
    t.integer  "atype",                                   default: 0
  end

  add_index "areas", ["station_id"], name: "index_areas_on_station_id", using: :btree

  create_table "cities", force: true do |t|
    t.string   "description"
    t.float    "lantitude",   limit: 24
    t.float    "langitude",   limit: 24
    t.integer  "province_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "commissions", force: true do |t|
    t.string   "name"
    t.float    "price",      limit: 24
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "counties", force: true do |t|
    t.string   "descripton"
    t.float    "lantitude",  limit: 24
    t.float    "langitude",  limit: 24
    t.integer  "city_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "densities", force: true do |t|
    t.integer  "area_id"
    t.integer  "count"
    t.integer  "year"
    t.integer  "month"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "densities", ["area_id"], name: "index_densities_on_area_id", using: :btree
  add_index "densities", ["month"], name: "index_densities_on_month", using: :btree
  add_index "densities", ["year"], name: "index_densities_on_year", using: :btree

  create_table "districts", force: true do |t|
    t.string   "name"
    t.integer  "city_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "express_areas", force: true do |t|
    t.integer  "expressman_id"
    t.integer  "area_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "expressmen", force: true do |t|
    t.string   "name"
    t.string   "mobile"
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "station_id"
    t.integer  "etype",      default: 0
    t.integer  "guoguo"
    t.integer  "syned",      default: 0
  end

  create_table "guo_guo_logs", force: true do |t|
    t.integer  "user_id"
    t.string   "user_name"
    t.string   "user_code"
    t.integer  "gtype"
    t.integer  "expressman_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "expressman_code"
    t.string   "expressman_name"
    t.string   "expressman_mobile"
  end

  create_table "keys", force: true do |t|
    t.string   "origin"
    t.string   "api_key"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "ktype"
    t.string   "api_secret"
  end

  create_table "man_messages", force: true do |t|
    t.integer  "is_success"
    t.string   "status_message"
    t.string   "courier_name"
    t.string   "courier_mobile"
    t.string   "account_id"
    t.string   "employee_no"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "syned",          default: 0
  end

  create_table "orders", force: true do |t|
    t.string   "station_name"
    t.integer  "station_id"
    t.decimal  "latitude",     precision: 15, scale: 10
    t.decimal  "longitude",    precision: 15, scale: 10
    t.integer  "area_id"
    t.decimal  "price",        precision: 10, scale: 2
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "count"
    t.string   "code"
  end

  create_table "people", force: true do |t|
    t.string   "name"
    t.string   "mobile"
    t.string   "identity"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "points", force: true do |t|
    t.decimal  "lantitude",      precision: 15, scale: 10
    t.decimal  "longitude",      precision: 15, scale: 10
    t.integer  "pointable_id"
    t.string   "pointable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "points", ["pointable_id"], name: "index_points_on_pointable_id", using: :btree
  add_index "points", ["pointable_type"], name: "index_points_on_pointable_type", using: :btree

  create_table "provinces", force: true do |t|
    t.string   "description"
    t.float    "lantitude",   limit: 24
    t.float    "langitude",   limit: 24
    t.integer  "count"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stations", force: true do |t|
    t.string   "description"
    t.text     "address"
    t.float    "lantitude",        limit: 24
    t.float    "longitude",        limit: 24
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "stationable_id"
    t.string   "stationable_type"
    t.integer  "stype",                       default: 0
  end

  add_index "stations", ["description"], name: "index_stations_on_description", using: :btree

  create_table "users", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
