require 'gems'

class GemData

  require 'thread'

  include Helpers
  attr_reader :gem_name

  def initialize(gem_name)
    @gem_name = gem_name
  end

  MAX_THREADS = 20

  def parallel_fetch_for(versions)
    @mutex1 = Mutex.new
    @cached_downloads_metatada ||= {}
    smallest_version = versions.map{|v| ComparableVersion.new(v)}.sort.first.str
    start_t = time_built(smallest_version)
    end_t = Time.now
    puts "fetching #{versions.size} download data requests"
    threads = []

    versions.map do |v|
      active_threads = threads.select{ |t| t.alive? }
      if active_threads.size > MAX_THREADS
        sleep 1 # busy wait thread pool
        redo
      else
        threads << Thread.new { fetch_downloads_metadata(v,start_t,end_t,@cached_downloads_metatada) }
      end
    end
    threads.map(&:join)
  end

  def fetch_downloads_metadata(version, start_time, end_time, cache_hash)
    key = key_for(version, start_time, end_time)
    data_received = Gems.downloads(gem_name, version, start_time, end_time)
    @mutex1.synchronize do
      # shared hash
      cache_hash[key] ||= data_received
    end
  end

  def prefetched_downloads_metadata(version, start_time, end_time)
    key = key_for(version, start_time, end_time)
    @cached_downloads_metatada[key]
  end

  def versions
    versions_metadata.map{|v| v["number"]}
  end

  def versions_built_at
    h = {}
    versions_metadata.map{|v| h.merge!(v["number"] => v["built_at"] )}
    h
  end

  def time_built(v)
    versions_built_at[v]
  end

  def versions_metadata
    @versions_metadata ||= Gems.versions(gem_name)
    # it should be a hash
    if @versions_metadata.is_a?(String)
      if @versions_metadata.match(/This rubygem could not be found/)
        raise(NoSuchGem, "This rubygem #{gem_name} could not be found")
      end
    end
    @versions_metadata
  end

  def key_for(v,s,e)
    "#{v}-#{time_format_str_small(s)}-#{time_format_str_small(e)}"
  end

  def total_for_version(version)
    @total_for_version ||= {}
    key = "#{version}"
    return @total_for_version[key] if @total_for_version[key]
    @total_for_version[key] ||= Gems.total_downloads(gem_name, version)
  end


end
