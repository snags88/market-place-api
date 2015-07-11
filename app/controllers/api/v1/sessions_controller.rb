class Api::V1::SessionsController < ApiController

  def create
    password = params[:session][:password]
    email = params[:session][:email]
    user = email.present? && User.find_by(email: email)

    if user.valid_password?(password)
      authenticate_user(user)
      render json: user, status: 200, location: api_user_path(user)
    else
      render json: {errors: "Invalid email or password"}, status: 422
    end
  end

  private
    def authenticate_user(user)
      sign_in(user, store: false)
      user.generate_authentication_token!
      user.save
    end
end
