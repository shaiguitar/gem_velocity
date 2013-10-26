class SingleVelocitator < BaseVelocitator

  # the one passed in
  # for :versions, it's just [version]
  attr_reader :version

  def initialize(gem_name, version)
    @version = version
    super(gem_name, [version])
  end

  def default_start
    time_format_str(Date.parse(time_built))
  end

  def time_built
    super(@version)
  end

  def default_max_value
    accumulated_downloads_per_day(@version).map {|day,total| total}.max
  end

  def line_data(start_t = nil, end_t = nil)
    range = nil
    if start_t && end_t
      range = compute_day_range_from_start_end(start_t,end_t)
    else
      range = effective_days_in_range
    end

    range.map do |d|
      downloads_per_day(version)[d] || 0
    end
  end

  def title
    "#{gem_name}-#{version}\n(downloads: #{num_downloads})"
  end

  def time_built
    super(@version)
  end

  def hide_legend?
    true
  end


end
