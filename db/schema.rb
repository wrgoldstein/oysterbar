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

ActiveRecord::Schema.define(version: 20160513183028) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "orders", force: :cascade do |t|
    t.string   "name"
    t.string   "phone"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "activation_code"
    t.string   "status"
  end

  create_table "orders_oysters", id: false, force: :cascade do |t|
    t.integer "order_id"
    t.integer "oyster_id"
    t.integer "count"
  end

  add_index "orders_oysters", ["order_id"], name: "index_orders_oysters_on_order_id", using: :btree
  add_index "orders_oysters", ["oyster_id"], name: "index_orders_oysters_on_oyster_id", using: :btree

  create_table "oysters", force: :cascade do |t|
    t.string   "name"
    t.integer  "count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "max"
  end

end
