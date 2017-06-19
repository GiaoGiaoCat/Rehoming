class CreateComments < ActiveRecord::Migration[5.1]
  def change
    create_table :comments do |t|
      t.references :commentable, polymorphic: true, index: true
      t.references :user, index: true
      t.text       :content
      t.references :forum, index: true
      t.integer    :replied_user_id
      t.datetime  :deleted_at, index: true
      t.timestamps null: false
    end

    add_index :comments, [:replied_user_id], name: 'comments_replied_user_id_index'
  end
end
