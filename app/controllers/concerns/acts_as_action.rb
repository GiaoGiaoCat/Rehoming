module ActsAsAction
  extend ActiveSupport::Concern

  included do
    before_action :load_parent
  end

  module ClassMethods
    def define_action_names(options = {})
      cattr_accessor :verb, :unverb
      self.verb = options[:verb].to_sym
      self.unverb = options[:unverb].to_sym
    end
  end

  def create
    @current_user.send(self.class.verb, @parent)
    head :created
  end

  def destroy
    @current_user.send(self.class.unverb, @parent)
    head :no_content
  end
end
