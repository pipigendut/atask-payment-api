class Transaction < ApplicationRecord
  belongs_to :stock
  belongs_to :source_wallet, class_name: 'Wallet', optional: true
  belongs_to :target_wallet, class_name: 'Wallet', optional: true

  validates :amount, numericality: { greater_than: 0 }
  validate :validate_source_and_target_wallets

  def execute_with_latest_stock_price
    # Update the stock price before performing any transactions
    stock.update_latest_price

    # Calculate the total transaction amount based on the stock's latest price
    transaction_amount = stock.last_price * amount

    # Ensure the source wallet has enough balance
    raise "Insufficient balance in source wallet" if source_wallet && source_wallet.balance < transaction_amount

    ActiveRecord::Base.transaction do
      # Perform the withdrawal from the source wallet if it exists
      source_wallet&.withdraw(transaction_amount) if source_wallet

      # Perform the deposit to the target wallet if it exists
      target_wallet&.deposit(transaction_amount) if target_wallet
    end
  end

  private

  def validate_source_and_target_wallets
    if source_wallet.nil? && target_wallet.nil?
      errors.add(:base, "Both source and target wallets cannot be nil")
    end
  end
end
