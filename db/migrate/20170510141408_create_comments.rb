class CreateComments < ActiveRecord::Migration[5.1]
  def change
    create_table :comments do |t|
      t.text       :content
      t.text       :image_url
      t.integer    :commentable_id
      t.string     :commentable_type
      t.references :user, index: true
      t.timestamps null: false
    end

    add_index :comments, [:commentable_id, :commentable_type], name: 'comments_commentable_index'
  end
end
