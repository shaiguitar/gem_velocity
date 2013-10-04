module Helpers

  extend self

  def time_format_str(date)
    date.strftime("%Y-%m-%dT%H:%M:%SZ")
  end
end
