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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120806143621) do

  create_table "addresses", :force => true do |t|
    t.text     "address",      :null => false
    t.string   "phone_number"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "patients", :force => true do |t|
    t.string   "name",                  :null => false
    t.string   "surname",               :null => false
    t.string   "gender",                :null => false
    t.date     "birthday"
    t.date     "next_appointment_date"
    t.integer  "mother_id"
    t.integer  "father_id"
    t.integer  "tutor_id"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
  end

  create_table "people", :force => true do |t|
    t.string   "name",                          :null => false
    t.string   "surname",                       :null => false
    t.string   "gender",                        :null => false
    t.date     "birthday"
    t.string   "cell_phone_number"
    t.string   "email"
    t.string   "type"
    t.integer  "address_id"
    t.integer  "company_id"
    t.integer  "company_person_identification"
    t.string   "occupation"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "name",                                  :null => false
    t.text     "address"
    t.string   "phone_number"
    t.string   "email"
    t.text     "other"
    t.boolean  "admin",              :default => false
    t.string   "encrypted_password"
    t.string   "salt"
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
  end

  add_index "users", ["username"], :name => "index_users_on_username", :unique => true

end
