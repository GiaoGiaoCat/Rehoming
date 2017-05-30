class CreateFeeds < ActiveRecord::Migration[5.1]
  def change
    create_table :feeds do |t|
      t.belongs_to :sourceable, polymorphic: true
      t.belongs_to :targetable, polymorphic: true
      t.integer    :event, null: false
      t.boolean :read, default: false
      t.timestamps null: false
    end
  end
end
