class WalletsController < ApplicationController
  def check_balance
    wallet = current_user.wallet
    assets_balance = current_user.stocks.sum(&:value)

    if wallet
      render json: { balance: wallet.balance, assets_balance: assets_balance }, status: :ok
    else
      render json: { error: "Wallet not found" }, status: :not_found
    end
  end
end
