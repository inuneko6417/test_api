require_relative 'lib/api_client'

API_BASE_URL = 'http://challenge.z2o.cloud/'
NICKNAME = 'Inuneko_Mizuki'

client = ApiClient.new(API_BASE_URL)
@learned_offset = 0.03
@diff_history = []
response_data = client.post_challenge(NICKNAME)

loop do
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

  challenge_id = response_data['id']
  actives_at_ms = response_data['actives_at']
  current_time_ms = Time.now.to_f * 1000
  sleep_duration = (actives_at_ms - current_time_ms) / 1000.0

  if sleep_duration > 0
    target_time = Time.now.to_f + sleep_duration - @learned_offset
    rough_wait = target_time - Time.now.to_f - 0.0015
    sleep(rough_wait) if rough_wait > 0

    while Time.now.to_f < target_time; end
  end

  response_data = client.put_challenge(challenge_id)

  if response_data['diff']
    @diff_history << response_data['diff']
    @diff_history.shift if @diff_history.size > 10

    if @diff_history.size >= 10
      weights = (1..@diff_history.size).to_a
      weighted_avg = @diff_history.zip(weights).sum { |d, w| d * w } / weights.sum.to_f
      @learned_offset = weighted_avg / 1000.0
    else
      @learned_offset = (@diff_history.sum / @diff_history.size.to_f) / 1000.0
    end

    @learned_offset = [[@learned_offset, 0.005].max, 0.050].min

    puts "Diff: #{response_data['diff']}ms, Offset: #{(@learned_offset * 1000).round(2)}ms, Total: #{response_data['total_diff']}ms"
  end
end
