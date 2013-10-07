class Velocitator

  include ::Helpers

  attr_accessor :gem_name, :versions

  # modifiers on the end result image being rendered.
  attr_accessor :date_range, :max_value, :min_value, :root

  def initialize(gem_name, versions)
    @gem_name = gem_name || raise(ArgumentError, 'need a name')
    @versions = if versions.is_a?(String) 
                  [versions]
                else
                  versions
                end || raise(ArgumentError, 'required versions')
  end

  def date_range=(args)
    return nil if args.nil?
    unless args.is_a?(Array) && args.size == 2
      raise(ArgumentError, "must pass a range with time objects like [start,end]")
    end
    @date_range = args.map{|t| time_format_str(t) }
  end

  def line_datas
    versions.map do |v|
      specific_days_in_range.map do |day_in_range|
        day_in_range = time_format_str_small(day_in_range) #conform to rubygems api format
        if gem_data.downloads_day(v).map {|day,total| day}.include?(day_in_range)
          total = Hash[gem_data.downloads_day(v)][day_in_range]
        else
          0
        end
      end
    end
  end

  def effective_date_range
    # we allow overwriting by passing a date range.
    if @date_range.is_a?(Array) && @date_range.compact.size==2
      @date_range
    else
      default_date_range
    end
  end

  # call, after you set all the attributes you want.
  # you can set (or there will be fallback defaults)
  #
  # max, min
  # date_range (leave nil for default values in either start or end)
  def gruff_builder
    opts = {
      :title => "#{gem_name}-#{versions.join("-")}",
      # just the first and last dates. give a small offset so it fits into the pciture.
      # line_datas.first.size -2 should be the max of any one of the line-datas, all should be same size.
      :labels => ({1 => time_format_str_small(effective_start_time), (line_datas.first.size-2) => time_format_str_small(effective_end_time) }),
      :max_value => max_value || default_max_value,
      :min_value => min_value || default_min_value,
      :line_datas => line_datas
    }
    builder = GruffBuilder.new(@root || Dir.pwd,nil,versions,gem_name,opts)
    builder
  end

  def graph(root_arg = nil, range = nil, min = nil, max = nil)
    # if nil, defaults will be used
    self.date_range = range
    self.root = root_arg
    self.max_value = max
    self.min_value = min
    gruff_builder.write
  end

  def specific_days_in_range
    all_days = []
    s = Date.parse(effective_start_time)
    e = Date.parse(effective_end_time)
    i = s
    while (i <= e )
      all_days << i
      i += 1.day
    end
    all_days
  end

  def default_min_value
    0
  end

  def default_max_value
    totals = []
    versions.each {|v|
      totals << gem_data.downloads_day(v).map {|day,total| total}
    }
    totals.flatten.compact.max
  end

  private

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
    earliest_start = versions.map{|v| Date.parse(time_built(v)) }.min
    default_start = time_format_str(earliest_start)
  end

  def default_end
    default_end = time_format_str(Time.now)
  end

  def time_built(version)
    gem_data.versions_built_at[version]
  end

  def gem_data
    @gem_data ||= GemData.new(@gem_name)
  end
end
