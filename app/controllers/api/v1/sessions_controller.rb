class Api::V1::SessionsController < ApiController

  def create
    password = params[:session][:password]
    email = params[:session][:email]
    user = email.present? && User.find_by(email: email)

    if user.valid_password?(password)
      sign_in(user, store: false)
      new_token(user)
      render json: user, status: 200, location: api_user_path(user)
    else
      render json: {errors: "Invalid email or password"}, status: 422
    end
  end

  def destroy
    user = User.find_by(auth_token: params[:id])
    new_token(user)
    head 204
  end

  private
    def new_token(user)
      user.generate_authentication_token!
      user.save
    end
end
