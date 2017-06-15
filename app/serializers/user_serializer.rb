class UserSerializer < ApplicationSerializer
  cache key: 'users'

  attribute :headimgurl
  attribute :nickname

  def nickname
    return nickname unless current_forum
    membership.preference.nickname
  end

  def id
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
