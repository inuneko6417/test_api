require 'net/http'
require 'json'
require 'uri'

class ApiClient
  def initialize(url)
    @url = url
  end

  def fetch
    uri = URI.parse(@url)
    response = Net::HTTP.get(uri)
    JSON.parse(response)
  rescue StandardError => e
    puts "API取得中にエラーが発生しました: #{e.message}"
    {}
  end
end
