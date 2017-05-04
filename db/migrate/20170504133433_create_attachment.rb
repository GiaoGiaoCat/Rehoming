class CreateAttachment < ActiveRecord::Migration[5.1]
  def change
    create_table :attachments do |t|
      t.integer :post_id
      t.integer :category
      t.text :url
      t.timestamps null: false
    end

    add_index :attachments, [:post_id], name: 'attachments_index'
  end
end
