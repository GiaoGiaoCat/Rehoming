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

ActiveRecord::Schema.define(version: 20170528151536) do

  create_table "attachments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string "attachable_type"
    t.bigint "attachable_id"
    t.integer "category"
    t.text "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["attachable_type", "attachable_id"], name: "index_attachments_on_attachable_type_and_attachable_id"
  end

  create_table "comments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string "commentable_type"
    t.bigint "commentable_id"
    t.bigint "user_id"
    t.text "content"
    t.bigint "forum_id"
    t.integer "replied_user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["commentable_type", "commentable_id"], name: "index_comments_on_commentable_type_and_commentable_id"
    t.index ["forum_id"], name: "index_comments_on_forum_id"
    t.index ["replied_user_id"], name: "comments_replied_user_id_index"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "favorites", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.bigint "user_id"
    t.string "favorable_type"
    t.bigint "favorable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["favorable_type", "favorable_id"], name: "index_favorites_on_favorable_type_and_favorable_id"
    t.index ["user_id"], name: "index_favorites_on_user_id"
  end

  create_table "feeds", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string "sourceable_type"
    t.bigint "sourceable_id"
    t.string "targetable_type"
    t.bigint "targetable_id"
    t.integer "event", null: false
    t.boolean "read", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sourceable_type", "sourceable_id"], name: "index_feeds_on_sourceable_type_and_sourceable_id"
    t.index ["targetable_type", "targetable_id"], name: "index_feeds_on_targetable_type_and_targetable_id"
  end

  create_table "forum_memberships", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.bigint "forum_id"
    t.bigint "user_id"
    t.integer "role"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["forum_id", "user_id"], name: "forum_memberships_index"
    t.index ["forum_id"], name: "index_forum_memberships_on_forum_id"
    t.index ["user_id"], name: "index_forum_memberships_on_user_id"
  end

  create_table "forum_preferences", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.bigint "forum_id", null: false
    t.boolean "member_list_protected", default: false, comment: "是否关闭圈子成员列表"
    t.boolean "postable_until_tomorrow", default: false, comment: "新成员一天后可以发主题"
    t.boolean "shared_post_allowed", default: true, comment: "允许分享主题"
    t.boolean "public_search_allowed", default: false, comment: "允许外部搜索"
    t.boolean "direct_message_allowed", default: true, comment: "允许成员私聊"
    t.boolean "membership_approval_needed", default: false, comment: "成员加入需要审批"
    t.integer "postable_role", default: 10, comment: "设置发主题权限"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "forums", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string "name", null: false
    t.text "description"
    t.text "cover"
    t.integer "category", null: false
    t.string "background_color"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "likes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.bigint "user_id"
    t.string "likeable_type"
    t.bigint "likeable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["likeable_type", "likeable_id"], name: "index_likes_on_likeable_type_and_likeable_id"
    t.index ["user_id"], name: "index_likes_on_user_id"
  end

  create_table "posts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.bigint "forum_id"
    t.bigint "user_id"
    t.text "content", limit: 16777215
    t.boolean "sticky", default: false, null: false
    t.boolean "recommended", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["forum_id"], name: "index_posts_on_forum_id"
    t.index ["recommended"], name: "index_posts_on_recommended"
    t.index ["sticky"], name: "index_posts_on_sticky"
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "user_forum_preferences", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.bigint "user_id"
    t.bigint "forum_id"
    t.string "nickname"
    t.boolean "follow_topics_on_mention", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["forum_id", "user_id"], name: "user_forum_preferences_index"
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string "unionid", limit: 191, comment: "全局唯一ID"
    t.string "nickname", limit: 191, comment: "昵称"
    t.text "headimgurl", comment: "头像URL"
    t.text "raw_info", comment: "微信用户原始信息"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["unionid"], name: "users_unionid_index"
  end

end
