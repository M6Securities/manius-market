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

ActiveRecord::Schema.define(version: 2021_12_28_232935) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "markets", force: :cascade do |t|
    t.string "display_name", default: ""
    t.string "path_name", default: ""
    t.string "email", default: ""
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "stripe_publishable_key"
    t.string "stripe_secret_key"
  end

  create_table "old_passwords", force: :cascade do |t|
    t.string "encrypted_password", null: false
    t.string "password_archivable_type", null: false
    t.integer "password_archivable_id", null: false
    t.string "password_salt"
    t.datetime "created_at", precision: 6
    t.index ["password_archivable_type", "password_archivable_id"], name: "index_password_archivable"
  end

  create_table "products", force: :cascade do |t|
    t.string "name", default: ""
    t.string "sku", default: ""
    t.decimal "price", precision: 8, scale: 2, default: "0.0"
    t.integer "stock", default: 0
    t.string "tax_code", default: "txcd_99999999"
    t.bigint "market_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "stripe_id"
    t.boolean "enabled", default: true
    t.boolean "shippable", default: true
    t.string "description", default: ""
    t.index ["market_id"], name: "index_products_on_market_id"
    t.index ["sku"], name: "index_products_on_sku"
    t.index ["stripe_id"], name: "index_products_on_stripe_id", unique: true
  end

  create_table "receive_items", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "receive_id"
    t.bigint "product_id"
    t.integer "quantity", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["product_id"], name: "index_receive_items_on_product_id"
    t.index ["receive_id"], name: "index_receive_items_on_receive_id"
  end

  create_table "receives", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.bigint "market_id"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["market_id"], name: "index_receives_on_market_id"
    t.index ["user_id"], name: "index_receives_on_user_id"
  end

  create_table "user_market_permissions", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "market_id"
    t.string "formatted_permissions", default: ""
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["market_id"], name: "index_user_market_permissions_on_market_id"
    t.index ["user_id"], name: "index_user_market_permissions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: 6
    t.datetime "remember_created_at", precision: 6
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at", precision: 6
    t.datetime "last_sign_in_at", precision: 6
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at", precision: 6
    t.datetime "confirmation_sent_at", precision: 6
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at", precision: 6
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "display_name", default: ""
    t.datetime "password_changed_at", precision: 6
    t.datetime "last_activity_at", precision: 6
    t.datetime "expired_at", precision: 6
    t.string "unique_session_id"
    t.boolean "enabled", default: true
    t.boolean "site_admin", default: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["expired_at"], name: "index_users_on_expired_at"
    t.index ["last_activity_at"], name: "index_users_on_last_activity_at"
    t.index ["password_changed_at"], name: "index_users_on_password_changed_at"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

end
