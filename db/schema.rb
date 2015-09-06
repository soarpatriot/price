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

ActiveRecord::Schema.define(version: 20150906064543) do

  create_table "areas", force: true do |t|
    t.integer  "station_id"
    t.float    "price",         limit: 24
    t.string   "label"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "commission_id"
  end

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

  create_table "points", force: true do |t|
    t.decimal  "lantitude",      precision: 15, scale: 10
    t.decimal  "longitude",      precision: 15, scale: 10
    t.integer  "pointable_id"
    t.string   "pointable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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
  end

end
