class CreateStocks < ActiveRecord::Migration[7.2]
  def change
    create_table :stocks do |t|
      t.decimal :quantity
      t.string :identifier
      t.string :status
      t.json :stock_data
      t.references :transaction, foreign_key: { to_table: :transactions }, index: true

      t.timestamps
    end
  end
end
