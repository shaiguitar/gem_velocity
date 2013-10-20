class MultipleVelocitator < BaseVelocitator

  def initialize(gem_name, versions)
    super(gem_name, versions)
  end

  def default_start
    base_earliest_time_for(versions)
  end

  def default_max_value
    base_max_for(versions)
  end

  def graph_options
    opts = {
      :title => title,
      :labels => ({1 => time_format_str_small(effective_start_time), (line_datas.first.size-2) => time_format_str_small(effective_end_time) }),
      :max_value => effective_max_value,
      :min_value => effective_min_value,
      :line_datas => line_datas,
    }
  end

  def line_datas
    default_line_datas
  end

  def title
    "#{gem_name}"
  end


end
