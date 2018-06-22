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

ActiveRecord::Schema.define(version: 20180622161515) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "audits", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "audits", ["user_id"], name: "index_audits_on_user_id", using: :btree

  create_table "containers", force: :cascade do |t|
    t.string   "code"
    t.date     "date_of_return_at"
    t.date     "deadline_to_return_at"
    t.date     "date_of_entry_to_warehose_at"
    t.date     "start_of_debt_at"
    t.boolean  "delivered"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "employee_id"
  end

  add_index "containers", ["user_id"], name: "index_containers_on_user_id", using: :btree

  create_table "dispatches", force: :cascade do |t|
    t.string   "code"
    t.date     "date"
    t.integer  "import_id"
    t.string   "contact"
    t.string   "phone_number_1"
    t.string   "phone_number_2"
    t.string   "description"
    t.string   "address"
    t.string   "city"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "employee_id"
  end

  create_table "drivers", force: :cascade do |t|
    t.string   "name"
    t.string   "identification"
    t.string   "phone"
    t.string   "carriage_plate"
    t.string   "trailer"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "employee_id"
  end

  create_table "import_products", force: :cascade do |t|
    t.integer  "import_id"
    t.integer  "product_id"
    t.string   "identification"
    t.integer  "container_id"
    t.decimal  "total_of_packages"
    t.decimal  "unit_by_package"
    t.decimal  "total_of_units"
    t.decimal  "net_weight"
    t.decimal  "gross_weight"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "employee_id"
  end

  create_table "imports", force: :cascade do |t|
    t.string   "code"
    t.date     "date"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "employee_id"
  end

  create_table "products", force: :cascade do |t|
    t.string   "name"
    t.string   "reference"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "employee_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "name"
    t.string   "phone"
    t.string   "address"
    t.boolean  "active"
    t.string   "identification"
    t.string   "contact_email"
    t.string   "contact_name"
    t.string   "contact_phone"
    t.integer  "employee_id"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "users_roles", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", using: :btree

  add_foreign_key "audits", "users"
  add_foreign_key "containers", "users"
  add_foreign_key "dispatches", "imports"
  add_foreign_key "import_products", "containers"
  add_foreign_key "import_products", "imports"
  add_foreign_key "import_products", "products"
  add_foreign_key "imports", "users"
end
