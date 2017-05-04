class CreatePosts < ActiveRecord::Migration[5.1]
  def change
    create_table :posts do |t|
      t.text :content, limit: 64.kilobytes
      t.timestamps null: false
    end
  end
end
