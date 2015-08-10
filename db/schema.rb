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

ActiveRecord::Schema.define(version: 20150809215637) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "fblikes", force: :cascade do |t|
    t.string   "user_name"
    t.string   "user_facebook_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "fbpost_id"
    t.string   "gender"
  end

  add_index "fblikes", ["fbpost_id"], name: "index_fblikes_on_fbpost_id", using: :btree

  create_table "fbposts", force: :cascade do |t|
    t.text     "story"
    t.text     "message"
    t.string   "url"
    t.string   "date"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "identity_id"
    t.integer  "likes"
  end

  add_index "fbposts", ["identity_id"], name: "index_fbposts_on_identity_id", using: :btree

  create_table "identities", force: :cascade do |t|
    t.string   "provider"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "user_id"
    t.string   "name"
    t.string   "image_url"
    t.string   "profile_url"
    t.string   "followers_count"
    t.string   "friends_count"
    t.string   "statuses_count"
    t.string   "access_token"
    t.string   "secret_token"
  end

  add_index "identities", ["user_id"], name: "index_identities_on_user_id", using: :btree

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
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "bpop_token"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "fblikes", "fbposts"
  add_foreign_key "fbposts", "identities"
  add_foreign_key "identities", "users"
end
