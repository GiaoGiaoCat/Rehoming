class CreateForums < ActiveRecord::Migration[5.1]
  def change
    create_table :forums do |t|
      t.string  :title, null: false
      t.text    :description
      t.text    :cover
      t.integer :category, null: false
      t.string  :background_color
      t.timestamps null: false
    end
  end
end
