require 'net/http'
require 'json'
require 'uri'

class LatestStockPrice
  BASE_URL = ENV.fetch('RAPIDAPI_HOST', 'https://latest-stock-price.p.rapidapi.com')
  RAPIDAPI_HOST = ENV.fetch('RAPIDAPI_HOST', 'latest-stock-price.p.rapidapi.com')
  RAPIDAPI_KEY = ENV.fetch('RAPIDAPI_KEY', '4a1c68bbdcmsh7d145bcfbc64adep133fe3jsn776586d98c62')

  def self.fetch_stocks
    fetch_data('/any')
  end

  def self.fetch_stock_by_identifier(identifier)
    stocks = fetch_data('/any')
    stocks.find { |stock| stock['identifier'] == identifier }
  end

  private

  def self.fetch_data(endpoint)
    uri = URI("#{BASE_URL}#{endpoint}")
    request = Net::HTTP::Get.new(uri)
    request['x-rapidapi-host'] = RAPIDAPI_HOST
    request['x-rapidapi-key'] = RAPIDAPI_KEY
    request['Content-Type'] = 'application/json'

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
      http.request(request)
    end

    handle_response(response)
  end

  def self.handle_response(response)
    case response
    when Net::HTTPSuccess
      JSON.parse(response.body)
    else
      raise "Error fetching data: #{response.code} - #{response.message}"
    end
  end
end
