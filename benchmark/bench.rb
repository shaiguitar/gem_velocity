#!/usr/bin/env ruby

BENCH_DIR = File.expand_path(File.dirname(__FILE__))
project = File.expand_path(File.join(BENCH_DIR, ".."))
Dir.chdir project
$:.unshift(project)
$:.unshift("lib")

require File.join(project,"lib", "gem_velocity")

require 'benchmark'
require 'perftools'

class PerfToolHelper
  class << self

    def clean_slate
      FileUtils.rm_rf(tmp_dir)
      FileUtils.mkdir_p(tmp_dir)
    end

    def tmp_dir
      "#{BENCH_DIR}/tmp"
    end

    attr_reader :paths
    def draw_it(path, &block)
      @paths ||= []
      @paths << path
      PerfTools::CpuProfiler.start(path)
      block.call
      PerfTools::CpuProfiler.stop
    end
  end
end

puts 'cleaning previous perftool'
PerfToolHelper.clean_slate

puts 'single'
puts Benchmark.measure {
  PerfToolHelper.draw_it("#{PerfToolHelper.tmp_dir}/0.0.5") do
    BaseVelocitator.create(:gem_name => "haml-i18n-extractor", :version => "0.0.5").graph
  end
}

puts 'aggregated'
puts Benchmark.measure {
  PerfToolHelper.draw_it("#{PerfToolHelper.tmp_dir}/0.0.x") do
    BaseVelocitator.create(:gem_name => "haml-i18n-extractor", :version => "0.0.x").graph
  end
}

puts 'multi'
puts Benchmark.measure {
  one = BaseVelocitator.create(:gem_name => "haml-i18n-extractor", :version => "0.0.16" )
  two = BaseVelocitator.create(:gem_name => "haml-i18n-extractor", :version => "0.0.17" )
  PerfToolHelper.draw_it("#{PerfToolHelper.tmp_dir}/0.0.16-0.0.17") do
    Multiplexer.new([one,two]).graph
  end
}

puts "Creating images for perftools..."
PerfToolHelper.paths.each do |perftool_data_path|
  system("pprof.rb --gif #{perftool_data_path} > #{perftool_data_path}.gif")
end

