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

ActiveRecord::Schema.define(version: 20141219095442) do

  create_table "resource_registrations", force: :cascade do |t|
    t.string   "ep",                         null: false
    t.string   "d"
    t.string   "et"
    t.integer  "lt",         default: 86400
    t.string   "con"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "resource_registrations", ["ep"], name: "index_resource_registrations_on_ep", unique: true

  create_table "target_attributes", force: :cascade do |t|
    t.integer  "typed_link_id", null: false
    t.string   "type",          null: false
    t.string   "value",         null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "target_attributes", ["typed_link_id"], name: "index_target_attributes_on_typed_link_id"

  create_table "typed_links", force: :cascade do |t|
    t.string   "path",                     null: false
    t.integer  "resource_registration_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "typed_links", ["resource_registration_id"], name: "index_typed_links_on_resource_registration_id"

end
