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

ActiveRecord::Schema[7.0].define(version: 2023_05_23_152540) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "dictionaries", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "dictionary_items", force: :cascade do |t|
    t.string "name"
    t.bigint "dictionary_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dictionary_id"], name: "index_dictionary_items_on_dictionary_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.bigint "user_id"
    t.string "title"
    t.datetime "due_time"
    t.datetime "done_time"
    t.text "note"
    t.boolean "highlited", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status", default: "added"
    t.index ["user_id"], name: "index_tasks_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "crypted_password"
    t.string "salt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "remember_me_token"
    t.datetime "remember_me_token_expires_at"
    t.string "reset_password_token"
    t.datetime "reset_password_token_expires_at"
    t.datetime "reset_password_email_sent_at"
    t.integer "access_count_to_reset_password_page", default: 0
    t.string "first_name"
    t.string "last_name"
    t.boolean "admin", default: false
    t.string "activation_state"
    t.string "activation_token"
    t.datetime "activation_token_expires_at"
    t.integer "failed_logins_count", default: 0
    t.datetime "lock_expires_at"
    t.string "unlock_token"
    t.string "user_name"
    t.index ["activation_token"], name: "index_users_on_activation_token"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["remember_me_token"], name: "index_users_on_remember_me_token"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token"
    t.index ["unlock_token"], name: "index_users_on_unlock_token"
  end

end
