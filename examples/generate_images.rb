#!/usr/bin/env ruby

require 'fileutils'

examples_dir  = File.expand_path(File.dirname(__FILE__))
images_dir    = File.join(examples_dir, "public","images")
project_root  = File.join(examples_dir, "..")
project_lib   = File.join(project_root,"lib")

$:.unshift(project_root)
$:.unshift(project_lib)
require 'lib/gem_velocity'

puts "Cleaning images directory before generating again."
FileUtils.rm_rf(images_dir)

puts "SINGLE VELOCITATOR"
@v1 = SingleVelocitator.new("haml-i18n-extractor", "0.0.17")
@v1.max_value = 800
file = @v1.graph

puts "SINGLE VELOCITATOR"
# these are basically equivalet:
# BaseVelocitator.create(:gem_name => "haml-i18n-extractor", :version => "0.0.16")
# BaseVelocitator.create(:full_name => "haml-i18n-extractor-0.0.16")
@v2 = SingleVelocitator.new("haml-i18n-extractor", "0.0.16")
@v2.max_value = 800
file = @v2.graph

puts "AGGREGATED VELOCITATOR"
# these are basically equivalet:
# BaseVelocitator.create(:gem_name => "haml-i18n-extractor", :version => "0.4.x")
# BaseVelocitator.create(:full_name => "haml-i18n-extractor-0.4.x")
@v3 = AggregatedVelocitator.new("haml-i18n-extractor", "0.4.x")
@v3.max_value = 800
file = @v3.graph

puts "MULTIPLEXING"
@velocitators = [@v1,@v2,@v3]
@multiplexer = Multiplexer.new(@velocitators)
file = @multiplexer.graph

puts "MULIPLEXING AGAIN"
@velocitators = []
@velocitators << BaseVelocitator.create(:gem_name  => "haml-i18n-extractor", :version => "0.4.x")
@velocitators << BaseVelocitator.create(:full_name => "haml-i18n-extractor-0.3.x")
@multiplexer = Multiplexer.new(@velocitators)
file = @multiplexer.graph
