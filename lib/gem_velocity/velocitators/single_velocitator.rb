class SingleVelocitator < BaseVelocitator

  def initialize(gem_name, version)
    @version = version
    super(gem_name, [version])
  end

  def default_start
    time_format_str(Date.parse(time_built(@version)))
  end

  def default_max_value
    gem_data.downloads_day(@version).map {|day,total| total}.max
  end

  def graph_options
    opts = {
      :title => title,
      :labels => ({1 => time_format_str_small(effective_start_time), (line_datas.first.size-2) => time_format_str_small(effective_end_time) }),
      :max_value => max_value || default_max_value,
      :min_value => min_value || default_min_value,
      :line_datas => line_datas
    }
  end

  def line_datas
    default_line_datas
  end

  def title
    "SingleVelocitator:#{gem_name}"
  end

end
