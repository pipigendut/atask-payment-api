class ApplicationController < ActionController::API
  before_action :authorize_request
  attr_reader :current_user

  private

  def authorize_request
    token = request.headers['Authorization']&.split(' ')&.last
    @current_user = decode_token(token)

    render json: { error: 'Not authorized' }, status: :unauthorized unless @current_user
  end

  def decode_token(token)
    payload = Auth::AuthManager.decode_token(token)
    return nil unless payload

    type = payload['type']
    user_id = payload['user_id']

    if type == 'user'
      User.find_by(id: user_id)
    elsif type == 'team'
      Team.find_by(id: user_id)
    end
  end
end
