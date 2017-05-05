class User::Generator < ActiveType::Record[User]
  validates :raw_info, presence: true

  def self.find_or_create_user_by(attributes)
    info = attributes[:raw_info]
    user = find_or_initialize_by(unionid: info.unionid)
    user.update(nickname: info.nickname, headimgurl: info.headimgurl, raw_info: info.to_h) if user.new_record?
    user
  end
end
