class UsersController < ApplicationController
  skip_before_action :authorize_request, only: [:create]

  def create
    user = User.new(user_params)

    if user.save
      render json: { message: "User created successfully", user: user }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
