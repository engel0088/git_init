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

ActiveRecord::Schema.define(:version => 20130815134809) do

  create_table "anonymous_questionnaires", :force => true do |t|
    t.integer  "anonymous_id"
    t.integer  "question_id"
    t.integer  "response_id"
    t.string   "response_text"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "anonymous_questionnaires", ["anonymous_id"], :name => "index_anonymous_questionnaires_on_anonymous_id"

  create_table "bonuses", :force => true do |t|
    t.integer  "sales_person_id"
    t.float    "amount"
    t.string   "note"
    t.integer  "payment_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.integer  "parent_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "commission_payments", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "contractors", :force => true do |t|
    t.integer  "user_id"
    t.string   "login"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "address"
    t.string   "city"
    t.integer  "state_id"
    t.string   "postal_code"
    t.string   "company_name"
    t.text     "company_description"
    t.string   "website"
    t.string   "phone"
    t.string   "mobile"
    t.integer  "mobile_carrier_id"
    t.string   "fax"
    t.string   "insurance_certificate"
    t.integer  "amount_insured_for"
    t.date     "date_insured_from"
    t.date     "date_insured_to"
    t.string   "license_number"
    t.string   "logo"
    t.string   "status"
    t.integer  "sales_person_id"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
  end

  add_index "contractors", ["sales_person_id"], :name => "index_contractors_on_sales_person_id"

  create_table "customer_services", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "keywords", :force => true do |t|
    t.string   "name"
    t.integer  "parent_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "leads", :force => true do |t|
    t.string   "name"
    t.string   "postal_code",     :limit => 5
    t.string   "phone",           :limit => 15
    t.string   "email"
    t.integer  "project_type_id"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "leads", ["project_type_id"], :name => "index_leads_on_project_type_id"

  create_table "memories", :force => true do |t|
    t.string   "tipe"
    t.string   "text"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "mobile_carriers", :force => true do |t|
    t.string  "name"
    t.string  "domain"
    t.string  "email_format"
    t.integer "digits"
  end

  create_table "monopolies", :force => true do |t|
    t.integer  "zip_code_id"
    t.integer  "project_type_id"
    t.integer  "contractor_id"
    t.date     "expiration"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "monopolies", ["contractor_id"], :name => "index_monopolies_on_contractor_id"
  add_index "monopolies", ["project_type_id"], :name => "index_monopolies_on_project_type_id"
  add_index "monopolies", ["zip_code_id"], :name => "index_monopolies_on_zip_code_id"

  create_table "monopoly_versions", :force => true do |t|
    t.integer  "monopoly_id"
    t.integer  "zip_code_id"
    t.integer  "category_id"
    t.integer  "contractor_id"
    t.date     "expiration"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "newsletter_attachments", :force => true do |t|
    t.string   "content"
    t.string   "title"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "newsletters", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "notifications", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "order_change_items", :force => true do |t|
    t.integer  "order_change_id"
    t.integer  "monopoly_id"
    t.string   "operation"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "order_changes", :force => true do |t|
    t.integer  "order_id"
    t.string   "status"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "order_mailers", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "order_payments", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "orders", :force => true do |t|
    t.integer  "contractor_id"
    t.integer  "sales_person_id"
    t.float    "amount"
    t.float    "discount"
    t.float    "commission"
    t.string   "credit_card_number"
    t.string   "credit_card_expiration"
    t.string   "credit_card_cvv"
    t.datetime "expiration"
    t.string   "status"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
  end

  create_table "paranoids", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "payments", :force => true do |t|
    t.string   "type"
    t.integer  "order_id"
    t.float    "amount"
    t.string   "method"
    t.string   "transaction_id"
    t.integer  "sales_person_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "possible_responses", :force => true do |t|
    t.string   "response"
    t.integer  "created_by"
    t.datetime "created_at",   :null => false
    t.integer  "updated_by"
    t.datetime "updated_at",   :null => false
    t.integer  "lock_version"
  end

  create_table "project_types", :force => true do |t|
    t.string   "name"
    t.integer  "lock_version"
    t.integer  "position"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "question_types", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "questionnaires", :force => true do |t|
    t.string   "name"
    t.integer  "created_by"
    t.datetime "created_at",   :null => false
    t.integer  "updated_by"
    t.datetime "updated_at",   :null => false
    t.integer  "lock_version"
  end

  create_table "questions", :force => true do |t|
    t.string   "name"
    t.text     "text"
    t.integer  "position"
    t.integer  "created_by"
    t.datetime "created_at",       :null => false
    t.integer  "updated_by"
    t.datetime "updated_at",       :null => false
    t.integer  "lock_version"
    t.integer  "questionnaire_id"
    t.integer  "question_type_id"
  end

  add_index "questions", ["question_type_id"], :name => "index_questions_on_question_type_id"
  add_index "questions", ["questionnaire_id"], :name => "index_questions_on_questionnaire_id"

  create_table "responses", :force => true do |t|
    t.integer  "question_id"
    t.integer  "possible_response_id"
    t.integer  "created_by"
    t.datetime "created_at",           :null => false
    t.integer  "updated_by"
    t.datetime "updated_at",           :null => false
    t.integer  "lock_version"
    t.integer  "position"
  end

  create_table "sales_people", :force => true do |t|
    t.integer  "user_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "login"
    t.string   "email"
    t.string   "address"
    t.string   "city"
    t.integer  "state_id"
    t.string   "postal_code",       :limit => 5
    t.string   "phone",             :limit => 15
    t.string   "mobile",            :limit => 15
    t.string   "fax",               :limit => 15
    t.integer  "commission_rate"
    t.integer  "contractors_count",               :default => 0
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
  end

  add_index "sales_people", ["state_id"], :name => "index_sales_people_on_state_id"
  add_index "sales_people", ["user_id"], :name => "index_sales_people_on_user_id"

  create_table "settings", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "states", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "activation_code",           :limit => 40
    t.datetime "activated_at"
    t.string   "state",                                   :default => "passive"
    t.datetime "deleted_at"
  end

  create_table "wished_monopolies", :force => true do |t|
    t.integer  "contractor_id"
    t.integer  "monopoly_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "wished_monopolies", ["contractor_id"], :name => "index_wished_monopolies_on_contractor_id"
  add_index "wished_monopolies", ["monopoly_id"], :name => "index_wished_monopolies_on_monopoly_id"

  create_table "zip_codes", :force => true do |t|
    t.integer "code"
    t.string  "city"
    t.string  "state_code", :limit => 2
    t.float   "lat"
    t.float   "lng"
    t.integer "elevation"
  end

end
