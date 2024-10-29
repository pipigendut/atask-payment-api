class CreateTransactions < ActiveRecord::Migration[7.2]
  def change
    create_table :transactions do |t|
      t.decimal :amount
      t.string :transaction_type
      t.string :type

      t.references :stock, foreign_key: { to_table: :transactions }, index: true
      t.references :source_wallet, foreign_key: { to_table: :wallets }, index: true
      t.references :target_wallet, foreign_key: { to_table: :wallets }, index: true

      t.timestamps
    end
  end
end
