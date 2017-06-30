class CreateAttachment < ActiveRecord::Migration[5.1]
  def change
    create_table :attachments do |t|
      t.references  :attachable, polymorphic: true, index: true
      t.references  :forum, index: true
      t.integer     :category, comment: '附件类型'
      t.text        :url, comment: '附件网址'
      t.timestamps null: false
    end
  end
end
