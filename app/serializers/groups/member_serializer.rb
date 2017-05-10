class Groups::MemberSerializer < ApplicationSerializer
  type 'members'
  attributes :nickname, :headimgurl
end
