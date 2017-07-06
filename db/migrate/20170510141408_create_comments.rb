class CreateComments < ActiveRecord::Migration[5.1]
  def change
    create_table :comments do |t|
      t.references :commentable, polymorphic: true, index: true
      t.references :user, index: true
      t.references :forum, index: true
      t.text       :content, comment: '正文'
      t.integer    :replied_user_id, comment: '提及者'
      t.integer :likes_count, null: false, default: 0, comment: '点赞数'
      t.datetime  :deleted_at, index: true
      t.timestamps null: false
    end

    add_index :comments, [:replied_user_id], name: 'comments_replied_user_id_index'
  end
end
