class CreateComments < ActiveRecord::Migration[5.1]
  def change
    create_table :comments do |t|
      t.text       :content
      t.text       :image_url
      t.references :commentable, polymorphic: true, index: true
      t.references :user, index: true
      t.timestamps null: false
    end
  end
end
