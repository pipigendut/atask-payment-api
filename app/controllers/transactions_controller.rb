class TransactionsController < ApplicationController
  def create
    transaction = Transaction.new(transaction_params)
    transaction.source_wallet = current_user.wallet if params[:source_wallet_id].nil?
    transaction.target_wallet = Wallet.find(params[:target_wallet_id]) if params[:target_wallet_id]

    if transaction.save
      render json: { message: 'Transaction created successfully', transaction: transaction }, status: :created
    else
      render json: { errors: transaction.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def transaction_params
    params.require(:transaction).permit(:amount, :stock_id, :source_wallet_id, :target_wallet_id)
  end
end
