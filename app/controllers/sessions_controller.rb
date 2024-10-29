class SessionsController < ApplicationController
  skip_before_action :authorize_request, only: [:create]

  def create
    user = find_user_by_type(session_params[:email], session_params[:type])

    if user && user.authenticate(session_params[:password])
      token = Auth::AuthManager.generate_token(user.id, user.class.name.downcase)
      render json: { token: token, message: "Login berhasil" }, status: :ok
    else
      render json: { error: "Email atau password salah atau tipe pengguna tidak valid" }, status: :unauthorized
    end
  end

  private

  def session_params
    params.require(:session).permit(:email, :type, :password)
  end

  def find_user_by_type(email, type)
    case type
    when 'user'
      User.find_by(email: email)
    when 'team'
      Team.find_by(email: email)
    else
      nil
    end
  end
end
