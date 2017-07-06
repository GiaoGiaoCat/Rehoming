class CreatePosts < ActiveRecord::Migration[5.1]
  def change
    create_table :posts do |t|
      t.references  :forum, index: true
      t.references  :user, index: true
      t.text    :content, limit: 64.kilobytes, comment: '正文'
      t.boolean :sticky, default: false, null: false, index: true, comment: '是否置顶'
      t.boolean :recommended, default: false, null: false, index: true, comment: '是否精华'
      t.integer :comments_count, null: false, default: 0, comment: '评论数'
      t.integer :likes_count, null: false, default: 0, comment: '点赞数'
      t.datetime  :deleted_at, index: true
      t.timestamps null: false
    end
  end
end
