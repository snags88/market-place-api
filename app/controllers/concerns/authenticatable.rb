module Authenticatable
  def current_user
    @current_user ||= User.find_by(auth_token: auth_token(request))
  end

  def authenticate_with_token
    render json: {errors: "Not authenticated"}, status: 401 unless current_user.present?
  end

  private
    def auth_token(request=nil)
      request.headers['Authorization'] if request
    end
end
