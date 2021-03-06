# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100406181512) do

  create_table "baskets", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "items", :force => true do |t|
    t.string   "name"
    t.string   "kind"
    t.integer  "qt",         :default => 0
    t.decimal  "price",      :default => 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payments", :force => true do |t|
    t.decimal  "amount",     :default => 0.0
    t.string   "name"
    t.string   "number"
    t.string   "code"
    t.string   "expires"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "basket_id"
  end

  create_table "selected_items", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "basket_id"
    t.integer  "item_id"
    t.integer  "quantity"
  end

end
