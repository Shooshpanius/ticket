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

ActiveRecord::Schema.define(version: 20140128072222) do

  create_table "actual_tasks", force: true do |t|
    t.integer  "user_id"
    t.integer  "ticket_to_group_id"
    t.integer  "ticket_to_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "attaches", force: true do |t|
    t.string   "object_type"
    t.integer  "object_id"
    t.string   "original_filename"
    t.string   "filename"
    t.string   "mime"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "root"
  end

  create_table "emails", force: true do |t|
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.string   "topic"
    t.text     "text"
    t.boolean  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups", force: true do |t|
    t.string   "name"
    t.string   "ticket_email"
    t.string   "ticket_email_password"
    t.integer  "leader"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "abbreviation"
    t.integer  "processing"
  end

  create_table "plans", force: true do |t|
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.integer  "ticket_root_id"
    t.datetime "start_scheduler"
    t.datetime "stop_scheduler"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "problems", force: true do |t|
    t.integer  "user_id"
    t.string   "topic"
    t.text     "text"
    t.boolean  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "problems_by_recipients", force: true do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "supply_data", force: true do |t|
    t.integer  "ticket_id"
    t.integer  "root"
    t.string   "name"
    t.string   "spec"
    t.string   "measure"
    t.string   "cnt"
    t.string   "estimated_date"
    t.string   "supplier"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ticket_children", force: true do |t|
    t.integer  "parent_user_ticket_id"
    t.integer  "parent_group_ticket_id"
    t.integer  "children_user_ticket_id"
    t.integer  "children_group_ticket_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "parent_id"
    t.integer  "child_id"
  end

  create_table "ticket_comments", force: true do |t|
    t.integer  "ticket_to_group_id"
    t.integer  "ticket_to_user_id"
    t.integer  "problem_id"
    t.text     "text"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "root"
  end

  create_table "ticket_roots", force: true do |t|
    t.string   "ticket_type"
    t.integer  "ticket_id"
    t.integer  "from_id"
    t.integer  "to_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "parent_id"
    t.datetime "delay"
  end

  create_table "ticket_to_groups", force: true do |t|
    t.integer  "initiator_id"
    t.integer  "group_id"
    t.string   "topic"
    t.text     "text"
    t.date     "deadline"
    t.integer  "completed"
    t.integer  "executor"
    t.integer  "actual"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "root"
    t.boolean  "in_scheduler"
    t.datetime "start_scheduler"
    t.datetime "stop_scheduler"
  end

  create_table "ticket_to_supplies", force: true do |t|
    t.integer  "initiator_id"
    t.integer  "group_id"
    t.string   "topic"
    t.text     "text"
    t.date     "deadline"
    t.integer  "completed"
    t.integer  "executor"
    t.integer  "actual"
    t.integer  "root"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ticket_to_users", force: true do |t|
    t.integer  "initiator_id"
    t.integer  "user_id"
    t.string   "topic"
    t.text     "text"
    t.date     "deadline"
    t.integer  "completed"
    t.integer  "actual"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "root"
    t.boolean  "in_scheduler"
    t.datetime "start_scheduler"
    t.datetime "stop_scheduler"
  end

  create_table "user_by_groups", force: true do |t|
    t.integer  "user_id"
    t.integer  "group_id"
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
    t.string   "position"
    t.string   "department"
    t.string   "auth_hash"
    t.string   "auth_last_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "fio"
    t.integer  "processing"
  end

end
