module CustomHeaderSetup
  def before_setup
    super
    token = JsonWebToken.issue(user_id: users(:victor).id)
    request.headers['Authorization'] = token
  end

  ActionController::TestCase.send(:include, self)
end
