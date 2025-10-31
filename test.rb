require_relative '../lib/challenge_parser'
require 'json'
sample_response = {
  "id" => 1,
  "actives_at" => 1730343000000,
  "called_at" => 1730343000500,
  "total_diff" => 500,
  "result" => {
    "attempts" => 3,
    "url" => "https://example.com/keyword"
  }
}

curl_cmd = "curl -X POST 'http://challenge.z2o.cloud/challenges?nickname=hoge'"
begin
  body = %x[#{curl_cmd}]
  parsed = JSON.parse(body)
  sample_response = parsed if parsed.is_a?(Hash)
rescue JSON::ParserError, Errno::ENOENT => e
  warn "curl または JSON パースに失敗しました。既定の sample_response を使用します: #{e.message}"
end

parser = ChallengeParser.new(sample_response)
parser.display_info
