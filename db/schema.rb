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

ActiveRecord::Schema.define(version: 20171212064453) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "mst_labels", force: :cascade do |t|
    t.integer "label_cd", null: false
    t.string  "label_nm", null: false
    t.index ["label_cd"], name: "index_mst_labels_on_label_cd", unique: true, using: :btree
  end

  create_table "mst_priorities", force: :cascade do |t|
    t.integer "priority_cd", null: false
    t.string  "priority_nm", null: false
    t.index ["priority_cd"], name: "index_mst_priorities_on_priority_cd", unique: true, using: :btree
  end

  create_table "mst_statuses", force: :cascade do |t|
    t.integer "status_cd", null: false
    t.string  "status_nm", null: false
    t.index ["status_cd"], name: "index_mst_statuses_on_status_cd", unique: true, using: :btree
  end

  create_table "tbl_task_infs", force: :cascade do |t|
    t.string   "task_nm",     null: false
    t.string   "task"
    t.integer  "label_cd"
    t.string   "deadline"
    t.integer  "status_cd"
    t.integer  "priority_cd"
    t.string   "personnel"
    t.string   "created_by"
    t.string   "updated_by"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "login",                       null: false
    t.string   "crypted_password",            null: false
    t.string   "password_salt"
    t.string   "persistence_token"
    t.string   "user_nm"
    t.string   "authority_level",   limit: 1, null: false
    t.string   "created_by"
    t.string   "updated_by"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

end
