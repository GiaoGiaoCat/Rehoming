class CreateForumMemberships < ActiveRecord::Migration[5.1]
  def change
    create_table :forum_memberships do |t|
      t.references  :forum
      t.references  :user
      t.integer     :status, default: 0
      t.datetime    :accepted_at
      t.timestamps null: false
    end

    add_index :forum_memberships, [:forum_id, :user_id], name: 'forum_memberships_index'
  end
end
