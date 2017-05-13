class CreateAttachment < ActiveRecord::Migration[5.1]
  def change
    create_table :attachments do |t|
      t.references  :attachable, polymorphic: true, index: true
      t.integer     :category
      t.text        :url
      t.timestamps null: false
    end
  end
end
