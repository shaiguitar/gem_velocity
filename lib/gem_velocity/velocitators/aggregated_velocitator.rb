class AggregatedVelocitator < BaseVelocitator

  attr_reader :aggregated_versions
  attr_reader :version

  def initialize(gem_name, top_level_ver)
    @gem_name = gem_name
    @version = @top_level_ver = top_level_ver
    @aggregated_versions = gem_data.versions.select{|v| v.match(/^#{Regexp.escape(top_level_ver)}/) }
    super(gem_name, @aggregated_versions)
  end

  def default_start
    base_earliest_time_for(@aggregated_versions)
  end

  def default_max_value
    base_max_for(@aggregated_versions) * @aggregated_versions.size
  end

  def line_data(start_t = nil, end_t = nil)
    range = nil
    if start_t && end_t
      range = compute_day_range_from_start_end(start_t,end_t)
    else
      range = effective_days_in_range
    end

    ret = Hash.new(0)
    @aggregated_versions.each do |v|
      range.each do |d|
        ret[d] += downloads_per_day(v)[d] || 0
      end
    end
    range.map{|d| ret[d] }
  end

  def title
    "#{@gem_name}: #{@top_level_ver}X\n(downloads: #{num_downloads})"
  end

end
