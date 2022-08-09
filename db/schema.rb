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

ActiveRecord::Schema[7.0].define(version: 2022_08_09_024001) do
  create_table "action_logs", force: :cascade do |t|
    t.string "loggable_type"
    t.bigint "loggable_id"
    t.string "action", default: "", null: false
    t.bigint "user_market_permission_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["loggable_type", "loggable_id"], name: "index_action_logs_on_loggable"
    t.index ["user_market_permission_id"], name: "index_action_logs_on_user_market_permission_id"
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", precision: nil, null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "cart_items", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "product_id"
    t.uuid "customer_id"
    t.bigint "quantity", default: 0
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["customer_id"], name: "index_cart_items_on_customer_id"
    t.index ["product_id"], name: "index_cart_items_on_product_id"
  end

  create_table "customers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "market_id"
    t.boolean "real", default: false
    t.string "session_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "email"
    t.index ["market_id"], name: "index_customers_on_market_id"
    t.index ["session_id"], name: "index_customers_on_session_id", unique: true
    t.index ["user_id"], name: "index_customers_on_user_id"
  end

  create_table "data_migrations", primary_key: "version", id: :string, force: :cascade do |t|
  end

  create_table "markets", force: :cascade do |t|
    t.string "display_name", default: ""
    t.string "path_name", default: ""
    t.string "email", default: ""
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "default_currency", default: "USD"
    t.boolean "enabled", default: false
  end

  create_table "old_passwords", force: :cascade do |t|
    t.string "encrypted_password", null: false
    t.string "password_archivable_type", null: false
    t.bigint "password_archivable_id", null: false
    t.string "password_salt"
    t.datetime "created_at", precision: nil
    t.index ["password_archivable_type", "password_archivable_id"], name: "index_password_archivable"
  end

  create_table "order_items", force: :cascade do |t|
    t.uuid "order_id"
    t.uuid "product_id"
    t.bigint "quantity", default: 0
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["order_id"], name: "index_order_items_on_order_id"
    t.index ["product_id"], name: "index_order_items_on_product_id"
  end

  create_table "orders", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "customer_id"
    t.string "address_line_1"
    t.string "address_line_2"
    t.string "city"
    t.string "state"
    t.string "zip"
    t.string "country"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "payment_status", default: 0
    t.bigint "status", default: 0
    t.string "shipping_name"
    t.bigint "total_price_cents"
    t.string "total_price_currency"
    t.index ["customer_id"], name: "index_orders_on_customer_id"
    t.index ["status"], name: "index_orders_on_status"
  end

  create_table "payment_gateways", force: :cascade do |t|
    t.bigint "gateway", null: false
    t.boolean "enabled", default: true
    t.jsonb "credentials", default: {}, null: false
    t.bigint "market_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["market_id"], name: "index_payment_gateways_on_market_id"
  end

  create_table "product_prices", force: :cascade do |t|
    t.uuid "product_id"
    t.bigint "price_cents", default: 0, null: false
    t.string "price_currency", default: "USD", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["product_id"], name: "index_product_prices_on_product_id"
  end

  create_table "products", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", default: ""
    t.string "sku", default: ""
    t.bigint "stock", default: 0
    t.string "tax_code", default: "txcd_99999999"
    t.bigint "market_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "enabled", default: true
    t.boolean "shippable", default: true
    t.string "description", default: ""
    t.index ["market_id"], name: "index_products_on_market_id"
    t.index ["sku"], name: "index_products_on_sku"
  end

  create_table "receive_items", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "receive_id"
    t.uuid "product_id"
    t.bigint "quantity", default: 0
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["product_id"], name: "index_receive_items_on_product_id"
    t.index ["receive_id"], name: "index_receive_items_on_receive_id"
  end

  create_table "receives", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.bigint "market_id"
    t.bigint "user_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["market_id"], name: "index_receives_on_market_id"
    t.index ["user_id"], name: "index_receives_on_user_id"
  end

  create_table "settings", force: :cascade do |t|
    t.string "app_name", default: "Manius Market"
    t.boolean "allow_registration", default: true
    t.boolean "allow_market_creation", default: true
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "user_market_permissions", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "market_id"
    t.string "formatted_permissions", default: ""
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["market_id"], name: "index_user_market_permissions_on_market_id"
    t.index ["user_id"], name: "index_user_market_permissions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.bigint "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at", precision: nil
    t.datetime "last_sign_in_at", precision: nil
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at", precision: nil
    t.datetime "confirmation_sent_at", precision: nil
    t.string "unconfirmed_email"
    t.bigint "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "display_name", default: ""
    t.datetime "password_changed_at", precision: nil
    t.datetime "last_activity_at", precision: nil
    t.datetime "expired_at", precision: nil
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

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
end
