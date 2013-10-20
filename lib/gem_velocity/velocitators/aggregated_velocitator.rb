class AggregatedVelocitator < BaseVelocitator

  attr_reader :aggregated_versions
  def initialize(gem_name, top_level_ver)
    @gem_name = gem_name
    @top_level_ver = top_level_ver
    @aggregated_versions = gem_data.versions.select{|v| v.match(/^#{Regexp.escape(top_level_ver)}/) }
    super(gem_name, @aggregated_versions)
  end

  def default_start
    base_earliest_time_for(@aggregated_versions)
  end

  def default_max_value
    base_max_for(@aggregated_versions) * @aggregated_versions.size
  end

  def graph_options
    opts = {
      :title => title,
      :labels => ({1 => time_format_str_small(effective_start_time), (line_datas.first.size-2) => time_format_str_small(effective_end_time) }),
      :max_value => effective_max_value,
      :min_value => effective_min_value,
      :line_datas => line_datas,
      :hide_legend => true
    }
  end

  def line_datas
    ret = Hash.new(0)
    @aggregated_versions.each do |v|
      effective_days_in_range.each do |d|
        ret[d] += downloads_per_day(v)[d] || 0
      end
    end
    [effective_days_in_range.map{|d| ret[d] }]
  end

  def title
    "#{@gem_name}: #{@top_level_ver}X\n(downloads: #{num_downloads})"
  end

end
