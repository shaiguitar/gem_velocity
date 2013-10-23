class Multiplexer

  # FIXME this needs some serious DRY vs BaseVelocitator, lots of logical duplication.
  # that probably requires eliminating the version stuff from base and also drying up the specs.

  include ::Helpers
  attr_reader :velocitators

  def initialize(velocitators)
    @velocitators = velocitators
  end

  def root
    velocitator_with_root = @velocitators.detect{|v| v.root }
    if velocitator_with_root
      velocitator_with_root.root
    else
      Dir.pwd
    end
  end

  def effective_start_time
    earliest_for(velocitators.map(&:effective_start_time))
  end

  def effective_end_time
    latest_for(velocitators.map(&:effective_end_time))
  end

  def effective_min_value
    velocitators.map(&:effective_min_value).min
  end

  def effective_max_value
    velocitators.map(&:effective_max_value).max
  end

  def graph_options
    opts = {
      :title      => title,
      :labels     => ({1 => time_format_str_small(effective_start_time),
                       (line_datas.first.size-2) => time_format_str_small(effective_end_time) }),
      :max_value  => effective_max_value,
      :min_value  => effective_min_value,
      :line_datas => line_datas,
      :type       => self.class.to_s
    }
  end

  def gruff_builder(path,versionz,gemname,graph_opts)
    GruffBuilder.new(path || Dir.pwd, nil, versionz, gemname, graph_opts)
  end

  def graph
    file = gruff_builder(root, @velocitators.map(&:version), gem_names, graph_options).write
    puts "Wrote graph to #{file}"
    file
  end

  def line_datas
    velocitators.map do |velocitator|
      velocitator.line_data(effective_start_time, effective_end_time)
    end
  end

  def title
    "Composite: #{gem_names}"
  end

  private

  def gem_names
    @velocitators.map(&:gem_name).sort.uniq.join(" ")
  end

end
