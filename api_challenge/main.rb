require_relative 'lib/api_client'
require_relative 'lib/challenge_parser'

# APIクライアントを作成してデータ取得
client = ApiClient.new("https://example.com/api/challenge")
response_data = client.fetch

# レスポンス解析
parser = ChallengeParser.new(response_data)
parser.display_info
