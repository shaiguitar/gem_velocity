class Factory

  include Helpers

  attr_reader :gem_name, :version, :versions, :type

  def initialize(options)

    # one ver passed
    if options[:gem_name] && options[:version]
      @gem_name = options[:gem_name]
      @version = options[:version]
      @type = type_from_version(@version)
      @versions = self.velocitator.versions
    elsif options[:full_name]
      @gem_name = name_from_full_name(options[:full_name])
      @version = version_from_full_name(options[:full_name])
      @type = type_from_version(@version)
      @versions = self.velocitator.versions
    end
  end

  def velocitator
    if @type == :aggregated
      @velocitator ||= AggregatedVelocitator.new(@gem_name, @version)
    elsif @type == :single
      @velocitator ||= SingleVelocitator.new(@gem_name, @version)
    else
      raise 'no velocitor found to generate!'
    end
  end

  private

  def name_from_full_name(str)
    str.split("-")[0..-2].join("-")
  end

  def version_from_full_name(str)
    str.split("-").last
  end

  def type_from_version(str)
    if str.last.downcase == "x"
      :aggregated
    else
      :single
    end
  end

end

