class GroupsUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :group_users do |t|
      t.integer :group_id
      t.integer :user_id
      t.timestamps null: false
    end

    add_index :group_users, [:group_id, :user_id], name: 'group_users_index'
  end
end
