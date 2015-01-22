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

ActiveRecord::Schema.define(version: 20150122061432) do

  create_table "user_resume_histories", force: :cascade do |t|
    t.integer  "user_id",                 null: false
    t.text     "diff",       default: "", null: false
    t.datetime "updated_at",              null: false
  end

  add_index "user_resume_histories", ["user_id", "updated_at"], name: "index_user_resume_histories_on_user_id_and_updated_at"

  create_table "user_resumes", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.text     "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "user_resumes", ["user_id"], name: "index_user_resumes_on_user_id"

  create_table "user_taggings", force: :cascade do |t|
    t.integer "user_id",     null: false
    t.integer "user_tag_id", null: false
  end

  add_index "user_taggings", ["user_id", "user_tag_id"], name: "index_user_taggings_on_user_id_and_user_tag_id", unique: true
  add_index "user_taggings", ["user_id"], name: "index_user_taggings_on_user_id"
  add_index "user_taggings", ["user_tag_id"], name: "index_user_taggings_on_user_tag_id"

  create_table "user_tags", force: :cascade do |t|
    t.string   "name",        null: false
    t.string   "search_hash", null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "user_tags", ["search_hash"], name: "index_user_tags_on_search_hash", unique: true

  create_table "users", force: :cascade do |t|
    t.string   "name",                               null: false
    t.string   "email",                              null: false
    t.string   "nick",                               null: false
    t.string   "member_number"
    t.string   "screen_name"
    t.string   "screen_name_kana"
    t.string   "encrypted_password",                 null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.integer  "suspend_reason",         default: 0, null: false
    t.date     "suspended_on"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["member_number"], name: "index_users_on_member_number", unique: true
  add_index "users", ["name"], name: "index_users_on_name", unique: true
  add_index "users", ["nick"], name: "index_users_on_nick", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  add_index "users", ["suspend_reason"], name: "index_users_on_suspend_reason"

end
