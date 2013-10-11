require 'gems'

class GemData
  def initialize(name)
    @name = name
  end

  def versions
    versions_metadata.map{|v| v["number"]}
  end

  def versions_built_at
    h = {}
    versions_metadata.map{|v| h.merge!(v["number"] => v["built_at"] )}
    h
  end

  # todo rename method? aggregated downloads per day
  def downloads_day(version, start_time = nil, end_time = Time.now)
    start_time = start_time || versions_built_at[version]
    total_so_far = 0
    found_first_download = false
    ret = downloads_metadata(version, start_time, end_time).map do |day,downloads_that_day|
      if found_first_download
        total_so_far += downloads_that_day
        [day, total_so_far]
      else
        if !downloads_that_day.zero?
          found_first_download = true
          total_so_far += downloads_that_day
          nil
        end
      end
    end.compact
  end

  def versions_metadata
    # cache api call.
    @versions_metadata ||= Gems.versions(@name)
    # it should be a hash
    if @versions_metadata.is_a?(String)
      if @versions_metadata.match(/This rubygem could not be found/)
        raise(NoSuchGem, "This rubygem could not be found")
      end
    end
    @versions_metadata
  end

  private

  def downloads_metadata(version, start_time, end_time)
    # cache api call.
    @downloads_metadata ||= {}
    return @downloads_metadata[version] if @downloads_metadata[version]
    @downloads_metadata[version] ||= Gems.downloads(@name, version, start_time, end_time).to_a
  end


end
