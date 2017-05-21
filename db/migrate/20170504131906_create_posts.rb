class CreatePosts < ActiveRecord::Migration[5.1]
  def change
    create_table :posts do |t|
      t.references  :group, index: true
      t.references  :user, index: true
      t.text    :content, limit: 64.kilobytes
      t.boolean :sticky, default: false, null: false, index: true
      t.boolean :recommended, default: false, null: false, index: true
      t.timestamps null: false
    end
  end
end
