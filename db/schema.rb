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

ActiveRecord::Schema.define(version: 20170604104451) do

  create_table "attachments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string "attachable_type"
    t.bigint "attachable_id"
    t.bigint "forum_id"
    t.integer "category", comment: "附件类型"
    t.text "url", comment: "附件网址"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["attachable_type", "attachable_id"], name: "index_attachments_on_attachable_type_and_attachable_id"
    t.index ["forum_id"], name: "index_attachments_on_forum_id"
  end

  create_table "comments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string "commentable_type"
    t.bigint "commentable_id"
    t.bigint "user_id"
    t.bigint "forum_id"
    t.text "content", comment: "正文"
    t.integer "replied_user_id", comment: "提及者"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["commentable_type", "commentable_id"], name: "index_comments_on_commentable_type_and_commentable_id"
    t.index ["deleted_at"], name: "index_comments_on_deleted_at"
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

  create_table "forum_memberships", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.bigint "forum_id"
    t.bigint "user_id"
    t.integer "status", default: 0, comment: "会员状态"
    t.datetime "accepted_at", comment: "审批时间"
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
    t.boolean "postable_with_membership", default: true, comment: "成员才可发帖"
    t.boolean "shared_post_allowed", default: true, comment: "允许分享主题"
    t.boolean "public_search_allowed", default: false, comment: "允许外部搜索"
    t.boolean "direct_message_allowed", default: true, comment: "允许成员私聊"
    t.boolean "membership_approval_needed", default: false, comment: "成员加入需要审批"
    t.text "postable_roles", comment: "发主题的成员权限"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "forums", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string "name", null: false, comment: "圈子名称"
    t.text "description", comment: "简介"
    t.text "cover", comment: "封面"
    t.integer "category", null: false, comment: "圈子归属类型"
    t.string "background_color", comment: "背景色"
    t.integer "posts_count", default: 0, null: false, comment: "圈子中的帖子数目"
    t.integer "image_attachments_count", default: 0, null: false, comment: "图片附件数目"
    t.integer "video_attachments_count", default: 0, null: false, comment: "视频附件数目"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_forums_on_deleted_at"
  end

  create_table "invitations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string "token"
    t.datetime "accepted_at"
    t.bigint "forum_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["forum_id"], name: "index_invitations_on_forum_id"
    t.index ["token"], name: "invitations_token_index"
    t.index ["user_id"], name: "index_invitations_on_user_id"
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
    t.text "content", limit: 16777215, comment: "正文"
    t.boolean "sticky", default: false, null: false, comment: "是否置顶"
    t.boolean "recommended", default: false, null: false, comment: "是否精华"
    t.integer "comments_count", default: 0, null: false, comment: "评论数"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_posts_on_deleted_at"
    t.index ["forum_id"], name: "index_posts_on_forum_id"
    t.index ["recommended"], name: "index_posts_on_recommended"
    t.index ["sticky"], name: "index_posts_on_sticky"
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "roles", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string "name"
    t.string "resource_type"
    t.bigint "resource_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["name"], name: "index_roles_on_name"
    t.index ["resource_type", "resource_id"], name: "index_roles_on_resource_type_and_resource_id"
  end

  create_table "user_forum_preferences", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.bigint "user_id"
    t.bigint "forum_id"
    t.string "nickname", comment: "圈子中的昵称"
    t.boolean "feed_allowed", default: true, comment: "是否接受动态"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["forum_id", "user_id"], name: "user_forum_preferences_index"
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string "unionid", limit: 191, comment: "全局唯一ID"
    t.string "nickname", limit: 191, comment: "昵称"
    t.text "headimgurl", comment: "头像URL"
    t.text "raw_info", comment: "微信用户原始信息"
    t.integer "posts_count", default: 0, null: false
    t.integer "favorites_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["unionid"], name: "users_unionid_index"
  end

  create_table "users_roles", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.bigint "user_id"
    t.bigint "role_id"
    t.index ["role_id"], name: "index_users_roles_on_role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
    t.index ["user_id"], name: "index_users_roles_on_user_id"
  end

end
