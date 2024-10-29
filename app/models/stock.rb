class Stock < ApplicationRecord
  def update_latest_price
    # Ambil data terbaru dari API dan update instance ini langsung
    latest_data = LatestStockPrice.fetch_any.find { |stock| stock['identifier'] == identifier }
    
    if latest_data
      update_from_api_data(latest_data)
    else
      puts "Data for identifier #{identifier} not found"
    end
  end

  def self.update_all_prices
    response_data = LatestStockPrice.fetch_any
    response_data.each do |data|
      update_from_api_data(data)
    end
  end

  private

  def update_from_api_data(data)
    # Update instance ini langsung tanpa mencari ulang identifier
    assign_attributes(
      change: data['change'],
      day_high: data['dayHigh'],
      day_low: data['dayLow'],
      last_price: data['lastPrice'],
      last_update_time: DateTime.parse(data['lastUpdateTime']),
      company_name: data.dig('meta', 'companyName'),
      industry: data.dig('meta', 'industry'),
      isin: data.dig('meta', 'isin'),
      open: data['open'],
      p_change: data['pChange'],
      per_change_30d: data['perChange30d'],
      per_change_365d: data['perChange365d'],
      previous_close: data['previousClose'],
      symbol: data['symbol'],
      total_traded_value: data['totalTradedValue'],
      total_traded_volume: data['totalTradedVolume'],
      year_high: data['yearHigh'],
      year_low: data['yearLow']
    )

    save!
  end
end
