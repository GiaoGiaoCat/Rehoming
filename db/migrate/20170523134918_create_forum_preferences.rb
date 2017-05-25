class CreateForumPreferences < ActiveRecord::Migration[5.1]
  def change
    create_table :forum_preferences do |t|
      t.references :forum, null: false, index: false
      t.boolean :member_list_protected, default: false, comment: '是否关闭圈子成员列表'
      t.boolean :postable_until_tomorrow, default: false, comment: '新成员一天后可以发主题'
      t.boolean :shared_post_allowed, default: true, comment: '允许分享主题'
      t.boolean :public_search_allowed, default: false, comment: '允许外部搜索'
      t.boolean :direct_message_allowed, default: true, comment: '允许成员私聊'
      t.boolean :membership_approval_needed, default: false, comment: '成员加入需要审批'
      t.integer :postable_role, default: 10, comment: '设置发主题权限'
      t.timestamps
    end
  end
end
