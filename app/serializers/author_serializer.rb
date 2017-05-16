class AuthorSerializer < ApplicationSerializer
  type 'authors'
  attributes :id, :nickname, :headimgurl
end
