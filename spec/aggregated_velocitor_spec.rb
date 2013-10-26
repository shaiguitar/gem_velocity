require 'spec_helper'

describe AggregatedVelocitator do
  before do
    @gem_name = "haml-i18n-extractor"
    # it's just a regex match ^version
    @major_version = "0x"
    @minor_version = "0.4.x"
  end

  it "can initialize and find out about all versions in a major" do
    velocitator = AggregatedVelocitator.new(@gem_name, @major_version)
    velocitator.versions.should == ["0.5.9", "0.5.8", "0.5.6", "0.5.5", "0.5.4", "0.5.3", "0.5.2", "0.5.1", "0.5.0", "0.4.3", "0.4.2", "0.4.1", "0.4.0", "0.3.5", "0.3.4", "0.3.2", "0.3.0", "0.2.1", "0.2.0", "0.1.0", "0.0.21", "0.0.20", "0.0.19", "0.0.18", "0.0.17", "0.0.16", "0.0.15", "0.0.12", "0.0.10", "0.0.9", "0.0.5"]
  end

  it "can initialize and find out about all versions in specific a minor" do
    velocitator = AggregatedVelocitator.new(@gem_name, @minor_version)
    velocitator.versions.should == ["0.4.3", "0.4.2", "0.4.1", "0.4.0"]
  end

  it "sends the first and last version passed as versions though" do
    velocitator = AggregatedVelocitator.new(@gem_name, @minor_version)
    velocitator.versions = ["0.4.3","0.4.0"]
  end

  it "sends only one graph that is the total of those versions" do
    velocitator = AggregatedVelocitator.new(@gem_name, @minor_version)
    velocitator.line_data.should_not be_empty # [1,2,3]
  end

  it "sets the max to the multiple of one of its members max * the amount of versions" do
    velocitator = AggregatedVelocitator.new(@gem_name, @minor_version)
    velocitator.default_max_value.should eq 356
  end

  it "sends only one graph and can draw a graph of it" do
    velocitator = AggregatedVelocitator.new(@gem_name, @minor_version)
    file = velocitator.graph
  end

  it "hides the legend caption" do
    velocitator = AggregatedVelocitator.new(@gem_name, "0.0.17")
    velocitator.graph_options[:hide_legend].should == true
  end

  it "should accumlate the same data as a single_velocitator" do
    a_velocitator = AggregatedVelocitator.new(@gem_name, "0.0.17")
    s_velocitator = SingleVelocitator.new(@gem_name, "0.0.17")
    a_velocitator.versions.should == s_velocitator.versions
    a_velocitator.graph_options[:line_datas].should == s_velocitator.graph_options[:line_datas]
  end

end
