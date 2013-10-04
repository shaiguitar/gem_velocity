class Coordinator

  include ::Helpers

  attr_accessor :gem_name, :version

  # modifiers on the end result image being rendered.
  attr_accessor :date_range, :max_value, :min_value, :root

  def initialize(gem_name, version)
    @gem_name = gem_name || raise(ArgumentError, 'need a name')
    @version = version || raise(ArgumentError, 'need a version')
  end

  def date_range=(args)
    unless args.is_a?(Array) && args.size == 2
      raise(ArgumentError, "must pass a range like [start,end]")
    end
    @date_range = args.map{|t| time_format_str(t) }
  end

  def line_data
    gem_data.downloads_day(version).map {|day,total| total}.compact
  end

  def effective_date_range
    if date_range
      if start_time && end_time
        range = start_time, end_time
      elsif start_time && !end_time
        range = start_time, default_end
      elsif !start_time && end_time
        range = default_start, end_time
      end
    else
      range = default_date_range
    end
    range
  end

  # call, after you set all the attributes you want.
  # you can set (or there will be fallback defaults)
  #
  # max, min
  # date_range (leave nil for default values in either start or end)
  def gruff_builder
    opts = {
      :title => "#{gem_name}-#{version}",
      # just the first and last dates. give a small offset so it fits into the pciture.
      :labels => ({1 => effective_start_time, (line_data.size-2) => effective_end_time }),
      :max_value => max_value || default_max_value,
      :min_value => min_value || default_min_value,
      :line_data => line_data
    }
    builder = GruffBuilder.new(@root || Dir.pwd,nil,version,gem_name,opts)
    builder
  end

  private

  def start_time
    date_range.first
  end

  def end_time
    date_range.last
  end

  def effective_start_time
    effective_date_range.first
  end

  def effective_end_time
    effective_date_range.last
  end


  def default_date_range
    range = default_start, default_end
  end

  def default_start
    default_start = time_built
  end
  
  def default_end
    default_end = time_format_str(Time.now)
  end

  def time_built
    gem_data.versions_built_at[version]
  end

  def gem_data
    gem_data ||= GemData.new(@gem_name)
  end

  def default_min_value
    0
  end

  def default_max_value
    gem_data.downloads_day(version).map {|day,total| total}.compact.max
  end

end
