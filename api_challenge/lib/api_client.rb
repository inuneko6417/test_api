require 'net/http'
require 'json'
require 'uri'
require 'time'

class ApiClient
  def initialize(base_url)
    @base_uri = URI.parse(base_url)
  end

  def post_challenge(nickname)
    uri = @base_uri.dup
    uri.path = '/challenges'
    uri.query = URI.encode_www_form({ nickname: nickname })

    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.request_uri)

    puts "Starting challenge with nickname: #{nickname}"
    response = http.request(request)
    handle_response(response)
  end

  def put_challenge(challenge_id)
    uri = @base_uri.dup
    uri.path = '/challenges'

    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Put.new(uri.request_uri)
    request['X-Challenge-Id'] = challenge_id

    response = http.request(request)
    handle_response(response)
  end

  private

  def handle_response(response)
    puts "Response: #{response.code} #{response.message}"
    body = JSON.parse(response.body)
    if response.is_a?(Net::HTTPSuccess)
      body
    else
      puts "Error: #{body['error']}"
      exit
    end
  rescue JSON::ParserError
    puts "Error: Failed to parse JSON response."
    exit
  end
end
