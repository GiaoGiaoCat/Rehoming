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

ActiveRecord::Schema.define(version: 20170706091020) do

  create_table "actions", force: :cascade do |t|
    t.string "action_type", null: false
    t.string "action_option"
    t.string "target_type"
    t.integer "target_id"
    t.string "user_type"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["target_type", "target_id", "action_type"], name: "index_actions_on_target_type_and_target_id_and_action_type"
    t.index ["user_type", "user_id", "action_type"], name: "index_actions_on_user_type_and_user_id_and_action_type"
  end

  create_table "attachments", force: :cascade do |t|
    t.string "attachable_type"
    t.integer "attachable_id"
    t.integer "forum_id"
    t.integer "category"
    t.text "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["attachable_type", "attachable_id"], name: "index_attachments_on_attachable_type_and_attachable_id"
    t.index ["forum_id"], name: "index_attachments_on_forum_id"
  end

  create_table "comments", force: :cascade do |t|
    t.string "commentable_type"
    t.integer "commentable_id"
    t.integer "user_id"
    t.integer "forum_id"
    t.text "content"
    t.integer "replied_user_id"
    t.integer "likes_count", default: 0, null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["commentable_type", "commentable_id"], name: "index_comments_on_commentable_type_and_commentable_id"
    t.index ["deleted_at"], name: "index_comments_on_deleted_at"
    t.index ["forum_id"], name: "index_comments_on_forum_id"
    t.index ["replied_user_id"], name: "comments_replied_user_id_index"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "forum_memberships", force: :cascade do |t|
    t.integer "forum_id"
    t.integer "user_id"
    t.integer "status", default: 0
    t.datetime "accepted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["forum_id", "user_id"], name: "forum_memberships_index"
    t.index ["forum_id"], name: "index_forum_memberships_on_forum_id"
    t.index ["user_id"], name: "index_forum_memberships_on_user_id"
  end

  create_table "forum_preferences", force: :cascade do |t|
    t.integer "forum_id", null: false
    t.boolean "member_list_protected", default: false
    t.boolean "postable_until_tomorrow", default: false
    t.boolean "postable_with_membership", default: true
    t.boolean "shared_post_allowed", default: true
    t.boolean "public_search_allowed", default: false
    t.boolean "direct_message_allowed", default: true
    t.boolean "membership_approval_needed", default: false
    t.text "postable_roles"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "forums", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.text "cover"
    t.integer "category", null: false
    t.string "background_color"
    t.integer "posts_count", default: 0, null: false
    t.integer "image_attachments_count", default: 0, null: false
    t.integer "video_attachments_count", default: 0, null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_forums_on_deleted_at"
  end

  create_table "invitations", force: :cascade do |t|
    t.string "token"
    t.datetime "accepted_at"
    t.integer "forum_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["forum_id"], name: "index_invitations_on_forum_id"
    t.index ["token"], name: "invitations_token_index"
    t.index ["user_id"], name: "index_invitations_on_user_id"
  end

  create_table "posts", force: :cascade do |t|
    t.integer "forum_id"
    t.integer "user_id"
    t.text "content", limit: 65536
    t.boolean "sticky", default: false, null: false
    t.boolean "recommended", default: false, null: false
    t.integer "comments_count", default: 0, null: false
    t.integer "likes_count", default: 0, null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_posts_on_deleted_at"
    t.index ["forum_id"], name: "index_posts_on_forum_id"
    t.index ["recommended"], name: "index_posts_on_recommended"
    t.index ["sticky"], name: "index_posts_on_sticky"
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.string "resource_type"
    t.integer "resource_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["name"], name: "index_roles_on_name"
    t.index ["resource_type", "resource_id"], name: "index_roles_on_resource_type_and_resource_id"
  end

  create_table "user_forum_preferences", force: :cascade do |t|
    t.integer "user_id"
    t.integer "forum_id"
    t.string "nickname"
    t.boolean "feed_allowed", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["forum_id", "user_id"], name: "user_forum_preferences_index"
  end

  create_table "users", force: :cascade do |t|
    t.string "unionid", limit: 191
    t.string "nickname", limit: 191
    t.text "headimgurl"
    t.text "raw_info"
    t.integer "posts_count", default: 0, null: false
    t.integer "favorites_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["unionid"], name: "users_unionid_index"
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
    t.index ["role_id"], name: "index_users_roles_on_role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
    t.index ["user_id"], name: "index_users_roles_on_user_id"
  end

end
