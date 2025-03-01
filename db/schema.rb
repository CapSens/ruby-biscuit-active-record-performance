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

ActiveRecord::Schema[8.0].define(version: 2025_03_01_141412) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "borrower_terms", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.date "due_date"
    t.integer "amount_to_pay"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_borrower_terms_on_project_id"
  end

  create_table "lender_terms", force: :cascade do |t|
    t.bigint "borrower_term_id", null: false
    t.bigint "subscription_id", null: false
    t.date "due_date"
    t.integer "amount_to_pay"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["borrower_term_id"], name: "index_lender_terms_on_borrower_term_id"
    t.index ["subscription_id"], name: "index_lender_terms_on_subscription_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "subscriptions", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.bigint "user_id", null: false
    t.integer "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_subscriptions_on_project_id"
    t.index ["user_id"], name: "index_subscriptions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "first_name"
    t.string "last_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "borrower_terms", "projects"
  add_foreign_key "lender_terms", "borrower_terms"
  add_foreign_key "lender_terms", "subscriptions"
  add_foreign_key "subscriptions", "projects"
  add_foreign_key "subscriptions", "users"
end
