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

ActiveRecord::Schema.define(version: 20170503142535) do

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string "unionid", limit: 191, comment: "全局唯一ID"
    t.string "nickname", limit: 191, comment: "昵称"
    t.text "headimgurl", comment: "头像URL"
    t.text "raw_info", comment: "微信用户原始信息"
    t.integer "sign_in_count", default: 0, null: false
    t.integer "failed_sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.string "current_sign_in_ip"
    t.datetime "last_sign_in_at"
    t.string "last_sign_in_ip"
    t.datetime "last_failed_sign_in_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["unionid"], name: "users_unionid_index"
  end

end
