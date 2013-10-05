module Helpers

  extend self

  def time_format_str(whatever)
    Date.parse(whatever.to_s).strftime("%Y-%m-%dT%H:%M:%SZ")
  end

  def time_format_str_small(whatever)
    Date.parse(whatever.to_s).strftime("%Y-%m-%d")
  end

end
