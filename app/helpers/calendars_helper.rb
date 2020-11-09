module CalendarsHelper

  def get_years
    years = []
    time = Time.zone.now
    -3.upto(6) { |i|
      years.push([time.years_since(i).strftime("%Y")+"年", time.years_since(i).strftime("%Y").to_i])
    }
    return years
  end

  # TODO: 選択した月で表示する日数を変更＆うるう年対応
  def get_days
    days = []
    1.upto(31) { |i| days.push(["#{i}日", i]) }
    return days
  end

  def get_hours
    hours = []
    0.upto(23) { |i| hours.push(["#{i}時", i]) }
    return hours
  end

  def get_months
    [['1月', 1], ['2月', 2], ['3月', 3], ['4月', 4], ['5月', 5], ['6月', 6], ['7月', 7], ['8月', 8], ['9月', 9], ['10月', 10], ['11月', 11], ['12月', 12]]
  end

  def get_minutes
    [['00分', 0], ['05分', 5], ['10分', 10], ['15分', 15], ['20分', 20], ['25分', 25], ['30分', 30], ['35分', 35], ['40分', 40], ['45分', 55], ['50分', 50], ['55分', 55]]
  end

  def get_duration_date(calendar, time)
    if calendar.start_time_epoc != Time.new(time.year, time.month, time.day).to_i && calendar.end_time_epoc != Time.new(time.year, time.month, time.day).to_i
      return "#{calendar.start_month}/#{calendar.start_day}-#{calendar.end_month}/#{calendar.end_day}"
    elsif calendar.end_time_epoc != Time.new(time.year, time.month, time.day).to_i
      return "#{format('%02d', calendar.start_hour)}:#{format('%02d', calendar.start_minute)}-#{calendar.end_month}/#{calendar.end_day}"
    elsif calendar.start_time_epoc != Time.new(time.year, time.month, time.day).to_i
      return "#{calendar.start_month}/#{calendar.start_day}-#{format('%02d', calendar.end_hour)}:#{format('%02d', calendar.end_minute)}"
    end
    return "#{format('%02d', calendar.start_hour)}:#{format('%02d', calendar.start_minute)}-#{format('%02d', calendar.end_hour)}:#{format('%02d', calendar.end_minute)}"
  end

end
