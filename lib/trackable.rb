module Trackable
  def update_tracked_fields!(request)
    update_tracked_fields(request)
    save(validate: false)
  end

  private

  def update_tracked_fields(request)
    old_current = current_sign_in_at
    new_current = Time.now.utc
    self.last_sign_in_at     = old_current || new_current
    self.current_sign_in_at  = new_current

    old_current_ip = current_sign_in_ip
    new_current_ip = request.remote_ip
    self.last_sign_in_ip     = old_current_ip || new_current_ip
    self.current_sign_in_ip  = new_current_ip

    self.sign_in_count ||= 0
    self.sign_in_count += 1
  end
end
