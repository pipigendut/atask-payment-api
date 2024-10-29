class SessionsController < ApplicationController
  skip_before_action :authorize_request, only: [:create]

  def create
    user = find_user_by_type(params[:email], params[:user_type])

    if user && user.authenticate(params[:password])
      token = Auth::AuthManager.generate_token(user.id, user.class.name)
      render json: { token: token, message: "Login berhasil" }, status: :ok
    else
      render json: { error: "Email atau password salah atau tipe pengguna tidak valid" }, status: :unauthorized
    end
  end

  private

  def find_user_by_type(email, user_type)
    case user_type
    when 'User'
      User.find_by(email: email)
    when 'Team'
      Team.find_by(email: email)
    else
      nil
    end
  end
end
