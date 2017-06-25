class CreateUserForumPreferences < ActiveRecord::Migration[5.1]
  def change
    create_table :user_forum_preferences do |t|
      t.references  :user, index: false
      t.references  :forum, index: false
      t.string      :nickname, comment: '圈子中的昵称'
      t.boolean     :feed_allowed, default: true, comment: '是否接受动态'
      t.timestamps
    end

    add_index :user_forum_preferences, [:forum_id, :user_id], name: 'user_forum_preferences_index'
  end
end
