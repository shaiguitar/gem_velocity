require 'fileutils'
begin
  require 'gruff'
rescue LoadError
  puts "You may need to install imagemagick, if rmagick isn't around..."
end

class GruffBuilder

  class NoData < StandardError; end

  MIN_VALUE = 0
  MAX_VALUE = 300

  attr_accessor :root, :relative_path, :version, :gem_name
  attr_accessor :title, :labels, :line_data, :min_value, :max_value

  def initialize(root, relative_path, version, gem_name, gruff_options = {})
    @root = root || raise("you must set a root. default is root/public/images")
    @relative_path = relative_path || "public/images/"
    @version = version
    @gem_name = gem_name
    #puts gruff_options.inspect
    @title = gruff_options[:title] || ""
    @labels = gruff_options[:labels] || {}
    @line_data = gruff_options[:line_data]
    @min_value = gruff_options[:min_value] || MIN_VALUE
    @max_value = gruff_options[:max_value] || MAX_VALUE
  end

  def relative_filename
    "#{@relative_path}#{filename}"
  end

  def filename
    "#{graph_name}.png"
  end

  def absolute_filename
    "#{absolute_destination}/#{filename}"
  end

  def write
    raise NoData if @line_data.nil?
    ensure_destination
    gruff.title = @title
    gruff.labels = @labels
    gruff.data graph_name.to_sym, @line_data
    gruff.minimum_value = @min_value
    gruff.maximum_value = @max_value
    gruff.write(absolute_filename)
    absolute_filename
  end

  private

  def absolute_destination
    File.expand_path(File.join(@root, @relative_path))
  end

  def ensure_destination
    FileUtils.mkdir_p(File.expand_path(absolute_destination))
  end

  def graph_name
    "#{gem_name}-#{version}"
  end

  def gruff
    @gruff ||= Gruff::Line.new
  end

end
