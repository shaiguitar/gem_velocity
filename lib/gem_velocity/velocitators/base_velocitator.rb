begin
  require 'active_support/all'
rescue
  'you need activesupport. please install'
end

class BaseVelocitator

  include ::Helpers

  attr_accessor :gem_name, :versions

  def self.create(options)
    sleep 10
    Factory.new(options).velocitator
  end

  def graph(root_arg = root, range = effective_date_range, min = effective_min_value, max = effective_max_value)
    set_overwritable_attrs(root_arg,range,min,max)
    file = gruff_builder(root, graph_options).write
    puts "Wrote graph to #{file}"
    file
  end

  def graph_options
    opts = {
      :title => title,
      :labels => ({1 => time_format_str_small(effective_start_time), (line_datas.first.size-2) => time_format_str_small(effective_end_time) }),
      :max_value => effective_max_value,
      :min_value => effective_min_value,
      :line_datas => line_datas,
      :hide_legend => hide_legend?,
      :type => self.class.to_s
    }
  end

  # modifiers on the end result image being rendered. Essentially these are the boundries
  # of the graph
  attr_reader :date_range, :max_value, :min_value, :root
  def date_range=(args); @passed_date_range = args && args.map{|t| time_format_str(t) } ;end
  def max_value=(max); @passed_max_value = max ;end
  def min_value=(min); @passed_min_value = min ;end
  def root=(path); @root = path ;end

  def effective_date_range
    @passed_date_range || default_date_range
  end 
  # some sugar
  def effective_start_time; effective_date_range.first ;end
  def effective_end_time; effective_date_range.last ;end

  def effective_days_in_range
    compute_day_range_from_start_end(effective_start_time,effective_end_time)
  end

  def effective_max_value
    @passed_max_value || default_max_value
  end

  def effective_min_value
    @passed_min_value || default_min_value
  end

  def totals_map_by_version
    h = {}
    versions.map do |v|
      total_for_version = gem_data.total_for_version(v)
      h.merge!(v => total_for_version)
    end
    h
  end

  def num_downloads
    sum_of_all_versions = totals_map_by_version.values.map {|t| t[:version_downloads]}.sum
    ActiveSupport::NumberHelper.number_to_delimited(sum_of_all_versions)
  end

  def time_built(version)
    gem_data.versions_built_at[version]
  end
  alias :built_at :time_built

  private

  def initialize(gem_name, versions)
    @gem_name = gem_name || raise(ArgumentError, 'need a name')
    @versions = versions || raise(ArgumentError, 'required versions')
    validate_correct_gem
    validate_correct_versions
  end

  def validate_correct_versions
    versions.each do |v|
      gem_data.versions.include?(v) || raise(NoSuchVersion,"version #{v} not found for #{gem_name}.")
    end
  end

  def validate_correct_gem
    # this will bomb out if bad version is passed.
    gem_data.versions_metadata
  end

  def set_overwritable_attrs(root_arg,range,min,max)
    self.date_range = range
    self.root = root_arg
    self.max_value = max
    self.min_value = min
  end

  def default_end
    default_end = time_format_str(Time.now)
  end

  def default_date_range
    [ default_start, default_end ]
  end

  def default_min_value
    0
  end

  def line_datas
    # aggregated and single are both just one, just line_data, but default to this
    # because of the multiplexer, since it does have line_datas
    [line_data]
  end

  def versions_for_legends
    [version]
  end

  def base_max_for(verzionz)
    totals = []
    verzionz.each {|v|
      totals << downloads_per_day(v).map {|day,total| total}
    }
    totals.flatten.compact.max
  end

  # returns # "2013-10-10" => 45
  def accumulated_downloads_per_day(version)
    # downloads_metadata comes back ordered by date
    # TODO behnchmark...refactor.
    #require 'pry'
    #binding.pry
    ret = Hash.new(0)
    from_api = gem_data.downloads_metadata(version, default_start, default_end)
    from_api.each_cons(2) do |p,n|
      #day,total pairs
      curr_total = n.last
      day = n.first
      previous_day = p.first
      ret[day] = curr_total + ret[previous_day]
    end
    ret
  end
  alias :downloads_per_day :accumulated_downloads_per_day

  def gem_data
    # need this memoized so the gem_data memoization works for the same instance
    @gem_data ||= GemData.new(@gem_name)
  end

  def gruff_builder(path,graph_opts)
    GruffBuilder.new(path || Dir.pwd, nil, versions_for_legends, gem_name, graph_opts)
  end

end
