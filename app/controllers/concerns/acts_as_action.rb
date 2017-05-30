module ActsAsAction
  extend ActiveSupport::Concern

  included do
    before_action :load_parent
  end

  module ClassMethods
    def define_action_names(options = {})
      cattr_accessor :verb, :unverb, :blk
      self.verb = options[:verb].to_sym
      self.unverb = options[:unverb].to_sym
      self.blk = options[:blk]
    end
  end

  def create
    @current_user.send(self.class.verb, @parent, &self.class.blk)
    # TODO: 根据 verb 参数和 parent 对象所属类不同，instrument 不同的事件
    # instrument 'created.post', obj_id: post.id, obj_class: 'post', handler_id: current_user.id
    head :created
  end

  def destroy
    @current_user.send(self.class.unverb, @parent)
    head :no_content
  end
end
