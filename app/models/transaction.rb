class Transaction < ApplicationRecord
  VALID_TRANSACTION_TYPES = %w[deposit withdraw transfer buy sell].freeze

  belongs_to :user
  belongs_to :stock, optional: true
  belongs_to :source_wallet, class_name: "Wallet", optional: true
  belongs_to :target_wallet, class_name: "Wallet", optional: true

  validates :amount, numericality: { greater_than: 0 }
  validates :transaction_type, inclusion: { in: VALID_TRANSACTION_TYPES }
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
    case transaction_type
    when "deposit"
      errors.add(:target_wallet, "can't be blank") if target_wallet.nil?
    when "withdraw"
      errors.add(:source_wallet, "can't be blank") if source_wallet.nil?
    when "transfer"
      errors.add(:source_wallet, "can't be blank") if source_wallet.nil?
      errors.add(:target_wallet, "can't be blank") if target_wallet.nil?
    when "buy", "sell"
      errors.add(:source_wallet, "can't be blank") if source_wallet.nil?
    end
  end
end
