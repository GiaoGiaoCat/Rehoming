class CreatePosts < ActiveRecord::Migration[5.1]
  def change
    create_table :posts do |t|
      t.integer :group_id
      t.integer :user_id
      t.text    :content, limit: 64.kilobytes
      t.timestamps null: false
    end

    add_index :posts, [:group_id, :user_id], name: 'posts_index'
  end
end
