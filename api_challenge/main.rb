require_relative 'lib/api_client'

# --- 設定 ---
API_BASE_URL = 'http://challenge.z2o.cloud/'
NICKNAME = 'Inuneko_Mizuki'
# -------------

client = ApiClient.new(API_BASE_URL)

# 1. チャレンジを開始
response_data = client.post_challenge(NICKNAME)

loop do
  # 3. チャレンジが終了したか確認
  if response_data.key?('result')
    puts "\nChallenge finished!"
    puts "Attempts: #{response_data.dig('result', 'attempts')}"
    if response_data.dig('result', 'url')
      puts "Success! URL: #{API_BASE_URL.chomp('/')}#{response_data.dig('result', 'url')}"
    else
      puts "Failed."
    end
    break
  end

  # 2. 呼出を実行
  challenge_id = response_data['id']
  actives_at_ms = response_data['actives_at']

  # 呼出予定時刻まで待機
  current_time_ms = Time.now.to_f * 1000
  sleep_duration = (actives_at_ms - current_time_ms) / 1000.0

  if sleep_duration > 0
    puts "\nWaiting for #{sleep_duration.round(3)} seconds..."
    sleep(sleep_duration - 0.1)
  end

  puts "Sending PUT request for challenge ID: #{challenge_id}"
  response_data = client.put_challenge(challenge_id)

  # 差分が500msを超えた場合も終了
  if response_data['total_diff'] && response_data['total_diff'] > 500
     puts "\nTotal diff exceeded 500ms. Challenge finished."
     if response_data.key?('result')
        puts "Attempts: #{response_data.dig('result', 'attempts')}"
        puts "Failed."
     end
     break
  end

  puts "Total diff: #{response_data['total_diff']}ms"
end