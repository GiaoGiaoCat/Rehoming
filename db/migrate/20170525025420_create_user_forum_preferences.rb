class CreateUserForumPreferences < ActiveRecord::Migration[5.1]
  def change
    create_table :user_forum_preferences do |t|
      t.references :user, index: false
      t.references :forum, index: false
      t.string     :nickname
      t.boolean :follow_topics_on_mention, default: true

      t.timestamps
    end

    add_index :user_forum_preferences, [:forum_id, :user_id], name: 'user_forum_preferences_index'
  end
end
