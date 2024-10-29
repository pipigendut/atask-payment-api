namespace :stocks do
  desc "Update stocks data from API"
  task update: :environment do
    Stock.update_all_prices
    puts "Stocks updated successfully!"
  end
end
