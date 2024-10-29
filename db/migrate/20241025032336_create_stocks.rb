class CreateStocks < ActiveRecord::Migration[7.2]
  def change
    create_table :stocks do |t|
      t.string :identifier
      t.decimal :change
      t.decimal :day_high
      t.decimal :day_low
      t.decimal :last_price
      t.datetime :last_update_time
      t.string :company_name
      t.string :industry
      t.string :isin
      t.decimal :open
      t.decimal :p_change
      t.decimal :per_change_30d
      t.decimal :per_change_365d
      t.decimal :previous_close
      t.string :symbol
      t.decimal :total_traded_value
      t.integer :total_traded_volume
      t.decimal :year_high
      t.decimal :year_low

      t.timestamps
    end
  end
end

