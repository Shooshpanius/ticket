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

ActiveRecord::Schema.define(version: 20130725043709) do

  create_table "emails", force: true do |t|
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.string   "topic"
    t.string   "text"
    t.boolean  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups", force: true do |t|
    t.string   "name"
    t.string   "ticket_email"
    t.integer  "leader"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ticket_comments", force: true do |t|
    t.integer  "ticket_to_group_id"
    t.integer  "ticket_to_user_id"
    t.string   "text"
    t.integer  "users_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ticket_to_groups", force: true do |t|
    t.integer  "initiator_id"
    t.integer  "groups_id"
    t.string   "topic"
    t.string   "text"
    t.date     "deadline"
    t.integer  "completed"
    t.integer  "executor"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ticket_to_users", force: true do |t|
    t.integer  "initiator_id"
    t.integer  "users_id"
    t.string   "topic"
    t.string   "text"
    t.date     "deadline"
    t.integer  "completed"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_by_groups", force: true do |t|
    t.integer  "users_id"
    t.integer  "groups_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "login"
    t.string   "f_name"
    t.string   "i_name"
    t.string   "o_name"
    t.integer  "position_id"
    t.string   "password"
    t.boolean  "status"
    t.string   "email"
    t.string   "ticket_email"
    t.string   "ticket_email_password"
    t.boolean  "admin"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
