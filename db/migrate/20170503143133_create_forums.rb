class CreateForums < ActiveRecord::Migration[5.1]
  def change
    create_table :forums do |t|
      t.string  :name, null: false
      t.text    :description
      t.text    :cover
      t.integer :category, null: false
      t.string  :background_color
      t.timestamps null: false
    end
  end
end
