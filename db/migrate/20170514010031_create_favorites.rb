class CreateFavorites < ActiveRecord::Migration[5.1]
  def change
    create_table :favorites do |t|
      t.references :user, index: true
      t.references :favable, polymorphic: true, index: true
      t.timestamps
    end
  end
end
