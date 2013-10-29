require 'gems'

class GemData

  attr_reader :gem_name

  def initialize(gem_name)
    @gem_name = gem_name
  end

  def versions
    versions_metadata.map{|v| v["number"]}
  end

  def versions_built_at
    h = {}
    versions_metadata.map{|v| h.merge!(v["number"] => v["built_at"] )}
    h
  end

  def versions_metadata
    # cache api call.
    @versions_metadata ||= Gems.versions(gem_name)
    # it should be a hash
    if @versions_metadata.is_a?(String)
      if @versions_metadata.match(/This rubygem could not be found/)
        raise(NoSuchGem, "This rubygem #{gem_name} could not be found")
      end
    end
    @versions_metadata
  end

  def total_for_version(version)
    @total_for_version ||= {}
    key = "#{version}"
    return @total_for_version[key] if @total_for_version[key]
    @total_for_version[key] ||= Gems.total_downloads(gem_name, version)
  end

  def downloads_metadata(version, start_time, end_time)
    # cache api call.
    @downloads_metadata ||= {}
    key = "#{version}-#{start_time}-#{end_time}"
    return @downloads_metadata[key] if @downloads_metadata[key]
    @downloads_metadata[key] ||= Gems.downloads(gem_name, version, start_time, end_time)
  end


end
