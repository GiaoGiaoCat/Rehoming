class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string  :unionid, limit: 191, comment: '全局唯一ID'
      t.string  :nickname, limit: 191, comment: '昵称'
      t.text    :headimgurl, comment: '头像URL'
      t.text    :raw_info, comment: '微信用户原始信息'

      t.integer   :sign_in_count, default: 0, null: false
      t.integer   :failed_sign_in_count, default: 0, null: false
      t.datetime  :current_sign_in_at
      t.string    :current_sign_in_ip
      t.datetime  :last_sign_in_at
      t.string    :last_sign_in_ip
      t.datetime  :last_failed_sign_in_at
      
      t.timestamps null: false
    end

    add_index :users, [:unionid], name: 'users_unionid_index'
  end
end
