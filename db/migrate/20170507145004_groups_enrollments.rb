class GroupsEnrollments < ActiveRecord::Migration[5.1]
  def change
    create_table :group_enrollments do |t|
      t.integer :group_id
      t.integer :user_id
      t.string  :nickname
      t.integer :role
      t.timestamps null: false
    end

    add_index :group_enrollments, [:group_id, :user_id], name: 'group_enrollments_index'
  end
end