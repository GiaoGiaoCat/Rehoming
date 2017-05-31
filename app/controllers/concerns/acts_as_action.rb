module ActsAsAction
  extend ActiveSupport::Concern

  included do
    before_action :load_parent
  end

  module ClassMethods
    def define_action_names(options = {})
      cattr_accessor :verb, :unverb, :instrument_name
      self.verb = options[:verb].to_sym
      self.unverb = options[:unverb].to_sym
      self.instrument_name = options[:instrument_name].to_s
    end
  end

  def create
    @current_user.send(verb, @parent)
    instrument instrument_name, obj_id: @parent.id, handler_id: current_user.id if instrument_name
    head :created
  end

  def destroy
    @current_user.send(unverb, @parent)
    head :no_content
  end
end
