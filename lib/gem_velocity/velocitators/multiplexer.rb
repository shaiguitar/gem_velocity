class Multiplexer < BaseVelocitator

  include ::Helpers
  attr_reader :velocitators

  def initialize(velocitators)
    @velocitators = velocitators
    # TODO what if there are multiple gem_names being multiplexed?
    @gem_name = velocitators.first.gem_name
    @versions = velocitators.map(&:versions).flatten
    after_init
  end

  def version
    raise "The multiplexer does not have a single version. try @versions."
  end

  def root
    velocitator_with_root = velocitators.detect{|v| v.root }
    if velocitator_with_root
      velocitator_with_root.root
    else
      Dir.pwd
    end
  end

  def default_start
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

  def line_datas
    velocitators.map do |velocitator|
      velocitator.line_data(effective_start_time, effective_end_time)
    end
  end

  def hide_legend?
    false
  end

  def versions_for_legends
    velocitators.map(&:version)
  end

  def title
    "Composite: #{gem_names}"
  end

  private

  def gem_names
    velocitators.map(&:gem_name).sort.uniq.join(" ")
  end

end
