class CreateTransactions < ActiveRecord::Migration[7.2]
  def change
    create_table :transactions do |t|
      t.decimal :amount
      t.string :transaction_type
      t.string :type

      t.references :user, null: false, foreign_key: true
      t.references :stock, null: true, foreign_key: true
      t.references :source_wallet, foreign_key: { to_table: :wallets }, index: true
      t.references :target_wallet, foreign_key: { to_table: :wallets }, index: true

      t.timestamps
    end
  end
end
