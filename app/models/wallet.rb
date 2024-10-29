class Wallet < ApplicationRecord
  belongs_to :walletable, polymorphic: true
  has_many :outgoing_transactions, class_name: 'Transaction', foreign_key: 'source_wallet_id'
  has_many :incoming_transactions, class_name: 'Transaction', foreign_key: 'target_wallet_id'

  validates :balance, numericality: { greater_than_or_equal_to: 0 }

  def deposit(amount)
    self.balance += amount
    save!
  end

  def withdraw(amount)
    raise "Insufficient balance" if balance < amount

    self.balance -= amount
    save!
  end
end
