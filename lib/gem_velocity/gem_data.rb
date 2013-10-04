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

  def downloads_day(version)
    total_so_far = 0
    # start day 0 as first download day.
    found_first_download = false
    ret = downloads_metadata(version).map do |day,downloads_that_day|
      if found_first_download
        total_so_far += downloads_that_day
        [day, total_so_far]
      else
        if !downloads_that_day.zero?
          found_first_download = true
          nil
        end
      end
    end.compact
  end

  private

  def versions_metadata
    # cache api call.
    @versions_metadata ||= Gems.versions(@name)
  end

  def downloads_metadata(version)
    # cache api call.
    @downloads_metadata ||= {}
    return @downloads_metadata[version] if @downloads_metadata[version]
    @downloads_metadata[version] ||= Gems.downloads(@name, version).to_a
  end


end
