class WalletsController < ApplicationController
  def check_balance
    wallet = current_user.wallet # Assuming current_user method retrieves the logged-in user

    if wallet
      render json: { balance: wallet.balance }, status: :ok
    else
      render json: { error: 'Wallet not found' }, status: :not_found
    end
  end
end
