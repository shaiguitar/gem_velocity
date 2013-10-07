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

  attr_accessor :root, :relative_path, :versions, :gem_name
  attr_accessor :title, :labels, :line_datas, :min_value, :max_value

  def initialize(root, relative_path, versions, gem_name, gruff_options = {})
    @root = root || raise("you must set a root. default is root/public/images")
    @relative_path = relative_path || "public/images/"
    @versions = versions.is_a?(Array) ? versions : raise("versions must be an array")
    @gem_name = gem_name
    @title = gruff_options[:title] || ""
    @labels = gruff_options[:labels] || {}
    @line_datas = gruff_options[:line_datas]
    @min_value = gruff_options[:min_value] || MIN_VALUE
    @max_value = gruff_options[:max_value] || MAX_VALUE
  end

  def relative_filename
    "#{@relative_path}#{filename}"
  end

  def filename
    "#{graph_name(versions.join("-"))}.png"
  end

  def absolute_filename
    "#{absolute_destination}/#{filename}"
  end

  def write
    raise NoData if @line_datas.nil? || @line_datas.empty?
    ensure_destination
    gruff.title = @title
    gruff.labels = @labels
    @line_datas.each_with_index do |line_data,index|
      gruff.data graph_name(@versions[index]), line_data
    end
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

  def graph_name(append_text = nil)
    append_text = append_text.nil? ? "" : "-#{append_text}"
    "#{gem_name}"+ append_text
  end

  def gruff
    @gruff ||= Gruff::Line.new
  end

end
