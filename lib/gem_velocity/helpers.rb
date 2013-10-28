module Helpers

  extend self

  def time_format_str(whatever)
    Date.parse(whatever.to_s).strftime("%Y-%m-%dT%H:%M:%SZ")
  end

  def time_format_str_small(whatever)
    Date.parse(whatever.to_s).strftime("%Y-%m-%d")
  end

  def earliest_for(whatevers)
    whatevers = whatevers.map{|s| Date.parse(s) } if whatevers.first.is_a?(String)
    time_format_str(whatevers.sort.first)
  end

  def latest_for(whatevers)
    whatevers = whatevers.map{|s| Date.parse(s) } if whatevers.first.is_a?(String)
    time_format_str(whatevers.sort.last)
  end

  def compute_day_range_from_start_end(s,e)
    all_days = []
    s = Date.parse(s)
    e = Date.parse(e)
    i = s
    while (i <= e )
      all_days << i
      i += 1.day
    end
    all_days.map{|d| time_format_str_small(d)}
  end

  def remove_trailing_x(str)
    str.gsub(/[xX]$/,"")
  end

end

# http://stackoverflow.com/questions/2051229/how-to-compare-versions-in-ruby
class ComparableVersion < Array
  def initialize s
    @str = s
    super(s.split('.').map { |e| e.to_i })
  end
  def str
    @str
  end
  def < x
    (self <=> x) < 0
  end
  def > x
    (self <=> x) > 0
  end
  def == x
    (self <=> x) == 0
  end
end


