class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string  :union_id, limit: 191, comment: '全局唯一ID'
      t.string  :nickname, limit: 191, comment: '昵称'
      t.text    :headimgurl, comment: '头像URL'
      t.text    :raw_info, comment: '微信用户原始信息'
      t.timestamps null: false
    end

    add_index :users, [:union_id], name: 'users_union_id_index'
  end
end
