class CreateForums < ActiveRecord::Migration[5.1]
  def change
    create_table :forums do |t|
      t.string    :name, null: false, comment: '圈子名称'
      t.text      :description, comment: '简介'
      t.text      :cover, comment: '封面'
      t.integer   :category, null: false, comment: '圈子归属类型'
      t.string    :background_color, comment: '背景色'
      t.integer   :posts_count, null: false, default: 0, comment: '圈子中的帖子数目'
      t.datetime  :deleted_at, index: true
      t.timestamps null: false
    end
  end
end
