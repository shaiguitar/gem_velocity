class SingleVelocitator < BaseVelocitator

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

  def graph_options
    opts = {
      :title => title,
      # todo change the -2 to -4? so if ifits in? if it's abvoe 4 fcors
      :labels => ({1 => time_format_str_small(effective_start_time), (line_datas.first.size-2) => time_format_str_small(effective_end_time) }),
      :max_value => effective_max_value,
      :min_value => effective_min_value,
      :line_datas => line_datas,
      :hide_legend => true
    }
  end

  def line_datas
    default_line_datas
  end

  def title
    "#{gem_name}-#{version}\n(downloads: #{num_downloads})"
  end

  def time_built
    super(@version)
  end
end
