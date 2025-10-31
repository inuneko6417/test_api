class ChallengeParser
  def initialize(data)
    @data = data
  end

  def display_info
    puts "チャレンジID: #{@data['id']}"
    puts "呼出予定時刻: #{format_time(@data['actives_at'])}"
    puts "処理受付時刻: #{format_time(@data['called_at'])}"
    puts "遅延合計(ms): #{@data['total_diff']}"
    puts "呼び出し回数: #{@data.dig('result', 'attempts')}"
    puts "URL: #{@data.dig('result', 'url') || 'なし'}"
  end

  private

  def format_time(ms)
    return '不明' unless ms
    Time.at(ms / 1000.0).strftime('%Y-%m-%d %H:%M:%S')
  end
end
