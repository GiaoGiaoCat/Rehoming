module ActsAsActionStore
  extend ActiveSupport::Concern

  included do
    before_action :load_parent
  end

  module ClassMethods
    def define_action_names(options = {})
      cattr_accessor :verb_name, :instrument_name, :authorize_name
      self.verb_name = options[:verb_name].to_sym
      self.instrument_name = options[:instrument_name].to_s
      self.authorize_name = options[:authorize_name].to_sym if options[:authorize_name]
    end
  end

  def create
    authorize @parent.forum, authorize_name if authorize_name
    current_user.create_action(verb_name, target: @parent)
    instrument instrument_name, sourceable: @parent, handler: current_user if instrument_name
    head :no_content
  end

  def destroy
    authorize @parent.forum, authorize_name if authorize_name
    current_user.destroy_action(verb_name, target: @parent)
    head :no_content
  end
end
