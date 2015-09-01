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

ActiveRecord::Schema.define(version: 20150831194006) do

  create_table "apps", force: :cascade do |t|
    t.integer "external_id",         limit: 4
    t.string  "name",                limit: 255
    t.text    "description",         limit: 65535
    t.string  "small_icon_url",      limit: 255
    t.integer "publisher_id",        limit: 4
    t.decimal "price",                             precision: 10
    t.string  "version",             limit: 255
    t.decimal "average_user_rating",               precision: 10
  end

  add_index "apps", ["external_id"], name: "index_apps_on_external_id", using: :btree
  add_index "apps", ["publisher_id"], name: "index_apps_on_publisher_id", using: :btree

  create_table "categories", force: :cascade do |t|
    t.integer "external_id", limit: 4
    t.string  "name",        limit: 255
  end

  add_index "categories", ["external_id"], name: "index_categories_on_external_id", using: :btree

  create_table "publishers", force: :cascade do |t|
    t.string "external_id", limit: 255
    t.string "name",        limit: 255
  end

  add_index "publishers", ["external_id"], name: "index_publishers_on_external_id", using: :btree

  create_table "rankings", force: :cascade do |t|
    t.integer "category_id",  limit: 4
    t.string  "monetization", limit: 255
    t.integer "rank",         limit: 4
    t.integer "app_id",       limit: 4
    t.integer "publisher_id", limit: 4
  end

  add_index "rankings", ["category_id", "monetization", "rank"], name: "index_rankings_on_category_id_and_monetization_and_rank", using: :btree
  add_index "rankings", ["category_id", "monetization"], name: "index_rankings_on_category_id_and_monetization", using: :btree

end
