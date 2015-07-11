module Authenticatable
  def current_user
    @current_user ||= User.find_by(auth_token: auth_token(request))
  end

  def auth_token(request=nil)
    request.headers['Authorization'] if request
  end
end
