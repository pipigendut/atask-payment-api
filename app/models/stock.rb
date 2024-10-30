class Stock < ApplicationRecord
  belongs_to :user

  has_many :transactions

  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :stock_data, presence: true

  def last_price
    stock_data["lastPrice"]
  end

  def value
    quantity * last_price.to_f
  end
end
