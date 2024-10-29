class StocksController < ApplicationController
  def index
    stocks = current_user.stocks

    stock_list = stocks.map do |stock|
      {
        identifier: stock.identifier,
        quantity: stock.quantity,
        price: stock.stock_data["lastPrice"],
        status: stock.status,
        transaction_id: stock.transaction_id,
        created_at: stock.created_at,
        updated_at: stock.updated_at
      }
    end

    render json: { stocks: stock_list }, status: :ok
  end

  def buy
    amount = params[:amount].to_f
    wallet = current_user.wallet

    # Validate amount
    if amount <= 0
      return render json: { error: 'Amount must be greater than zero' }, status: :unprocessable_entity
    end

    if wallet.balance < amount
      return render json: { error: 'Insufficient balance' }, status: :unprocessable_entity
    end

    stock_data = LatestStockPrice.fetch_stock_by_identifier(params[:identifier])

    if stock_data.nil?
      return render json: { error: 'Stock not found' }, status: :not_found
    end

    ActiveRecord::Base.transaction do
      quantity = calculate_buy_amount(amount, stock_data["lastPrice"])

      if quantity <= 0
        return render json: { error: 'Insufficient funds to buy stock' }, status: :unprocessable_entity
      end

      wallet.update!(balance: wallet.balance - amount)

      transaction = Transaction.create!(
        amount: amount,
        user: current_user,
        transaction_type: 'buy',
        source_wallet_id: wallet.id,
        target_wallet_id: nil
      )

      Stock.create!(
        transaction_record: transaction,
        quantity: quantity,
        identifier: stock_data["identifier"],
        status: 'buy',
        stock_data: stock_data
      )
    end

    render json: { message: 'Purchase successful' }, status: :ok
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :unprocessable_entity
  rescue => e
    render json: { error: 'An unexpected error occurred' }, status: :internal_server_error
  end

  def sell
    identifier = params[:identifier]
    quantity_to_sell = params[:quantity]
    wallet = current_user.wallet

    stock = Stock.find_by(identifier: identifier, status: 'buy')

    if stock.nil?
      return render json: { error: 'Stock not found or not owned' }, status: :not_found
    end

    if quantity_to_sell <= 0 || quantity_to_sell > stock.quantity
      return render json: { error: 'Invalid quantity to sell' }, status: :unprocessable_entity
    end

    stock_data = LatestStockPrice.fetch_stock_by_identifier(identifier)
    if stock_data.nil?
      return render json: { error: 'Stock price not found' }, status: :not_found
    end

    total_amount = quantity_to_sell * stock_data["lastPrice"]

    ActiveRecord::Base.transaction do
      wallet.update!(balance: wallet.balance + total_amount)

      if stock.quantity == quantity_to_sell
        stock.update!(status: 'sold', quantity: 0)
      else
        stock.update!(quantity: stock.quantity - quantity_to_sell)
      end

      Transaction.create!(
        amount: total_amount,
        user: current_user,
        transaction_type: 'sell',
        source_wallet_id: wallet.id,
        target_wallet_id: nil
      )
    end

    render json: { message: 'Sale successful', total_amount: total_amount }, status: :ok
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :unprocessable_entity
  rescue => e
    render json: { error: 'An unexpected error occurred' }, status: :internal_server_error
  end

  private

  def calculate_buy_amount(amount, last_price)
    return 0 if last_price <= 0
    (amount / last_price)
  end
end
