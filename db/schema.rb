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

ActiveRecord::Schema.define(version: 20160331074457) do

  create_table "day_messages", force: :cascade do |t|
    t.integer  "post_id",          limit: 4
    t.integer  "impression_count", limit: 4
    t.integer  "click_count",      limit: 4
    t.integer  "comment_count",    limit: 4
    t.integer  "praise_count",     limit: 4
    t.integer  "qq_share",         limit: 4
    t.integer  "wechat_share",     limit: 4
    t.integer  "weibo_share",      limit: 4
    t.integer  "genre",            limit: 4
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.string   "day_mark",         limit: 255
  end

  create_table "documents", force: :cascade do |t|
    t.string   "file_file_name",    limit: 255
    t.string   "file_content_type", limit: 255
    t.integer  "file_file_size",    limit: 4
    t.datetime "file_updated_at"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.integer  "file_state",        limit: 4,   default: 0
  end

  create_table "hour_messages", force: :cascade do |t|
    t.integer  "post_id",          limit: 4
    t.integer  "impression_count", limit: 4
    t.integer  "click_count",      limit: 4
    t.integer  "comment_count",    limit: 4
    t.integer  "praise_count",     limit: 4
    t.integer  "qq_share",         limit: 4
    t.integer  "wechat_share",     limit: 4
    t.integer  "weibo_share",      limit: 4
    t.integer  "genre",            limit: 4
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.string   "hour_mark",        limit: 255
  end

  create_table "sum_messages", force: :cascade do |t|
    t.integer  "post_id",          limit: 4
    t.integer  "impression_count", limit: 4
    t.integer  "click_count",      limit: 4
    t.integer  "comment_count",    limit: 4
    t.integer  "praise_count",     limit: 4
    t.integer  "qq_share",         limit: 4
    t.integer  "wechat_share",     limit: 4
    t.integer  "weibo_share",      limit: 4
    t.integer  "genre",            limit: 4
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "username",               limit: 180,   default: "",   null: false
    t.integer  "genre",                  limit: 4,     default: 4,    null: false
    t.string   "face_pic",               limit: 180
    t.string   "background_image_pic",   limit: 180
    t.string   "_alias",                 limit: 180
    t.boolean  "comments_push_switch",                 default: true
    t.boolean  "praises_push_switch",                  default: true
    t.boolean  "letter_push_switch",                   default: true
    t.string   "phone",                  limit: 180
    t.text     "description",            limit: 65535
    t.string   "private_token",          limit: 180
    t.string   "weibo_uid",              limit: 180
    t.string   "qq_uid",                 limit: 180
    t.string   "wechat_uid",             limit: 180
    t.string   "twitter_uid",            limit: 180
    t.integer  "message_count",          limit: 4,     default: 0
    t.string   "source",                 limit: 180
    t.integer  "letter_count",           limit: 4,     default: 0
    t.string   "phone_verify",           limit: 255
    t.string   "address",                limit: 180
    t.boolean  "status",                               default: true
    t.boolean  "state",                                default: true
    t.string   "email",                  limit: 180,   default: "",   null: false
    t.string   "encrypted_password",     limit: 180,   default: "",   null: false
    t.string   "reset_password_token",   limit: 180
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,     default: 0,    null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 180
    t.string   "last_sign_in_ip",        limit: 180
    t.string   "confirmation_token",     limit: 180
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email",      limit: 180
    t.integer  "old_id",                 limit: 4
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
