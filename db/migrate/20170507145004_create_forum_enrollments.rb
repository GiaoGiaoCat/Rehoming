class CreateForumEnrollments < ActiveRecord::Migration[5.1]
  def change
    create_table :forum_enrollments do |t|
      t.references  :forum
      t.references  :user
      t.string      :nickname
      t.integer     :role
      t.timestamps null: false
    end

    add_index :forum_enrollments, [:forum_id, :user_id], name: 'forum_enrollments_index'
  end
end
