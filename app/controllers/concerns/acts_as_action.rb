module ActsAsAction
  extend ActiveSupport::Concern

  included do
    before_action :load_parent
  end

  module ClassMethods
    def define_action_names(options = {})
      cattr_accessor :verb, :unverb, :instrument_name, :authorize_name
      self.verb = options[:verb].to_sym
      self.unverb = options[:unverb].to_sym
      self.instrument_name = options[:instrument_name].to_s
      self.authorize_name = options[:authorize_name].to_sym if options[:authorize_name]
    end
  end

  def create
    authorize @parent.forum, authorize_name if authorize_name
    @current_user.send(verb, @parent)
    instrument instrument_name, obj_id: @parent.id, handler_id: current_user.id if instrument_name
    head :created
  end

  def destroy
    authorize @parent.forum, authorize_name if authorize_name
    @current_user.send(unverb, @parent)
    head :no_content
  end
end
