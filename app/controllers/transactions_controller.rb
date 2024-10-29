class TransactionsController < ApplicationController
  def deposit
    amount = params.require(:amount).to_f

    ActiveRecord::Base.transaction do
      current_user.wallet.deposit(amount)

      Transaction.create!(
        amount: amount,
        user: current_user,
        transaction_type: 'deposit',
        source_wallet_id: nil,
        target_wallet_id: current_user.wallet.id
      )
    end

    render json: { message: 'Deposit successful' }, status: :ok
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :unprocessable_entity
  rescue => e
    render json: { error: 'An unexpected error occurred' }, status: :internal_server_error
  end

  def withdraw
    amount = params.require(:amount).to_f

    ActiveRecord::Base.transaction do
      current_user.wallet.withdraw(amount)

      Transaction.create!(
        amount: amount,
        user: current_user,
        transaction_type: 'withdraw',
        source_wallet_id: current_user.wallet.id,
        target_wallet_id: nil
      )
    end

    render json: { message: 'Withdrawal successful' }, status: :ok
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :unprocessable_entity
  rescue => e
    render json: { error: 'An unexpected error occurred' }, status: :internal_server_error
  end

  def transfer
    amount = params.require(:amount).to_f
    target_wallet = Wallet.find(params[:target_wallet_id])

    ActiveRecord::Base.transaction do
      current_user.wallet.withdraw(amount)
      target_wallet.deposit(amount)

      Transaction.create!(
        amount: amount,
        user: current_user,
        transaction_type: 'transfer',
        source_wallet_id: current_user.wallet.id,
        target_wallet_id: target_wallet.id
      )
    end

    render json: { message: 'Transfer successful' }, status: :ok
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :unprocessable_entity
  rescue => e
    render json: { error: 'An unexpected error occurred' }, status: :internal_server_error
  end
end
