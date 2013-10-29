#!/usr/bin/env ruby

project = File.expand_path(File.dirname(__FILE__), "..")
Dir.chdir project
$:.unshift(project)
$:.unshift("lib")
require File.join(project,"lib", "gem_velocity")

require 'benchmark'

puts 'single'
puts Benchmark.measure { 
  BaseVelocitator.create(:gem_name => "haml-i18n-extractor", :version => "0.0.5").graph
}

puts 'aggregated'
puts Benchmark.measure { 
  BaseVelocitator.create(:gem_name => "haml-i18n-extractor", :version => "0.0.x").graph
}

puts 'multi'
puts Benchmark.measure { 
  one = BaseVelocitator.create(:gem_name => "haml-i18n-extractor", :version => "0.0.16" )
  two = BaseVelocitator.create(:gem_name => "haml-i18n-extractor", :version => "0.0.17" )
  Multiplexer.new([one,two]).graph
}

