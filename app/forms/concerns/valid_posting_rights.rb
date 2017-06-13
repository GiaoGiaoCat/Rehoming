module ValidPostingRights
  extend ActiveSupport::Concern

  included do
    validate :user_should_in_forum
    validate :postable_until_tomorrow
  end

  private

  def user_should_in_forum
    errors.add :base, :not_in_forum unless author_membership
  end

  def postable_until_tomorrow
    return unless forum.postable_until_tomorrow?
    errors.add :base, :postable_until_tomorrow if author_membership.created_at.next_day > Time.current
  end
end
