class User < ApplicationRecord
  has_secure_password
  has_many :transactions, dependent: :destroy
  has_many :stocks, through: :transactions
  has_one :wallet, as: :walletable, dependent: :destroy

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true

  after_create :create_wallet

  def generate_token
    Auth::AuthManager.generate_token(id, self.class.name)
  end

  private

  def create_wallet
    Wallet.create(walletable: self, balance: 0) # Menginisialisasi wallet dengan saldo 0
  end
end
