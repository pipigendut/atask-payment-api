class Stock < ApplicationRecord
  belongs_to :transaction_record, class_name: 'Transaction', foreign_key: 'transaction_id'

  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :stock_data, presence: true
end
