begin
  require 'active_support/all'
rescue
  'you need activesupport. please install'
end

class BaseVelocitator

  include ::Helpers

  attr_accessor :gem_name, :versions

  def graph(root_arg = nil, range = nil, min = nil, max = nil)
    set_overwritable_attrs(root_arg,range,min,max)
    gruff_builder.write
  end

  # modifiers on the end result image being rendered.
  attr_reader :date_range, :max_value, :min_value, :root
  def date_range=(args); @passed_date_range = args && args.map{|t| time_format_str(t) } ;end
  def max_value=(max); @passed_max_value = max ;end
  def min_value=(min); @passed_min_value = min ;end
  def root=(path); @root = path ;end

  def effective_date_range
    @passed_date_range || [ default_start, default_end ]
  end

  def effective_max_value
    @passed_max_value || default_max_value
  end

  def effective_min_value
    @passed_min_value || default_min_value
  end

  private

  def initialize(gem_name, versions)
    @gem_name = gem_name || raise(ArgumentError, 'need a name')
    @versions = versions || raise(ArgumentError, 'required versions')
    validate_correct_gem
    validate_correct_versions
  end

  def validate_correct_versions
    versions.each do |v|
      gem_data.versions.include?(v) || raise(NoSuchVersion,"version not found for #{versions}.")
    end
  end

  def validate_correct_gem
    # this will bomb out if bad version is passed.
    gem_data.versions_metadata
  end

   # if it's nil, the defaults will be used
  # basically these are the graph boundries
  def set_overwritable_attrs(root_arg,range,min,max)
    self.date_range = range
    self.root = root_arg
    self.max_value = max
    self.min_value = min
  end

  def default_end
    default_end = time_format_str(Time.now)
  end

  def default_min_value
    0
  end

  def default_line_datas
    # refactor me?
    versions.map do |v|
      specific_days_in_range.map do |day_in_range|
        day_in_range = time_format_str_small(day_in_range) #conform to rubygems api format
        if gem_data.downloads_day(v).map {|day,total| day}.include?(day_in_range)
          # get the total for that day
          total = Hash[gem_data.downloads_day(v)][day_in_range]
        else
          0
        end
      end
    end
  end

  # a little sugar
  def effective_start_time; effective_date_range.first ;end
  def effective_end_time; effective_date_range.last ;end

  # helper method to convert [start,end] into a 
  # start..end range of day instances
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

  def gem_data
    # need this memoized so the gem_data memoization works for the same instance
    @gem_data ||= GemData.new(@gem_name)
  end

  def gruff_builder
    GruffBuilder.new(@root || Dir.pwd,nil,versions,gem_name,graph_options)
  end

  # it's just shorter syntax
  def time_built(version)
    gem_data.versions_built_at[version]
  end
 
end
