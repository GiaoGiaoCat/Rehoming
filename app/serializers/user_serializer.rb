class UserSerializer < ApplicationSerializer
  cache key: 'user'

  attributes :headimgurl, :posts_count, :favorites_count
  attribute :nickname

  def nickname
    object.forum_nickname(current_forum)
  end

  def to_param
    return to_param unless current_forum
    membership.to_param
  end

  private

  def current_forum
    view_variables[:current_forum]
  rescue
    nil
  end

  def membership
    object.membership_by_forum(current_forum)
  end
end
