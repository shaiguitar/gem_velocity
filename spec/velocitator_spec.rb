require 'spec_helper'

# https://github.com/shaiguitar/rubygems.org/compare/api_not_returning_all_results_over_90_days?expand=1

describe "a Velocitator rendering graphs" do

  # testing single_velocitator is enough to test base
  it "can render a graph" do
    velocitator = SingleVelocitator.new("haml-i18n-extractor", "0.0.17")
    velocitator.date_range = [ 7.days.ago, 3.days.ago ]
    velocitator.root = SpecHelper.tmpdir

    # Plausible to change this?
    # the values for the two days mentioned in the date range.
    # should this be the specific date range values?? aggregated since when? not aggregated?
    velocitator.graph_options[:line_datas].should == [[303, 303, 303, 304, 304]]

    velocitator.graph_options[:title].should == "haml-i18n-extractor-0.0.17\n(downloads: 377)"
    velocitator.graph_options[:labels].should == ({1=>"2013-09-13", (velocitator.line_datas.first.size-2) =>"2013-09-17"})
    velocitator.graph_options[:max_value].should == 306 # the max in the range (time.now)
    velocitator.graph_options[:min_value].should == 0

    file = velocitator.graph
    File.exist?(file).should be_true
    #`open #{file} -a preview.app`
    #Kernel.sleep(10)
  end

  it "has a shortcut graph method #1" do
    velocitator = SingleVelocitator.new("haml-i18n-extractor", "0.0.17")
    file = velocitator.graph(SpecHelper.tmpdir,[1.day.ago, Time.now])
    File.exist?(file).should be_true
  end

  it "has a shortcut graph method #2" do
    velocitator = SingleVelocitator.new("haml-i18n-extractor", "0.0.17")
    file = velocitator.graph
    File.exist?(file).should be_true
  end

  it "has a shortcut graph metho #3" do
    velocitator = SingleVelocitator.new("haml-i18n-extractor", "0.0.17")
    file = velocitator.graph(nil,nil,0,1000)
    File.exist?(file).should be_true
  end
end

describe SingleVelocitator do
  it 'raises if you dont pass name and version(s)' do
    lambda { SingleVelocitator.new(nil,nil) }.should raise_error ArgumentError
  end

  it 'raises if the gem is not found' do
    lambda { SingleVelocitator.new("NOSICHGEMPlZ123","0.1") }.should raise_error NoSuchGem
  end

  it 'raises if the version is not found' do
    lambda { SingleVelocitator.new("haml-i18n-extractor","100.999.42.666.pre") }.should raise_error NoSuchVersion
  end

  it "holds the totals of the gem" do
    velocitator = SingleVelocitator.new("haml-i18n-extractor", "0.0.17")
    velocitator.totals.first[:version_downloads].should eq 377
    #binding.pry
  end

  it "sets a specific date range according to the gem's info" do
    velocitator = SingleVelocitator.new("haml-i18n-extractor", "0.0.17")
    velocitator.effective_date_range.should eq ["2013-06-16T00:00:00Z", "2013-09-20T00:00:00Z"]
  end

  it "can override the default time ranges if its in the range" do
    velocitator = SingleVelocitator.new("haml-i18n-extractor", "0.0.17")
    velocitator.date_range = [1.day.ago, Time.now]
    velocitator.effective_date_range.should eq ["2013-09-19T00:00:00Z", "2013-09-20T00:00:00Z"]
  end

  it "can override a max and min" do
    velocitator = SingleVelocitator.new("haml-i18n-extractor", "0.0.17")
    lambda {
      velocitator.max_value = 500
      velocitator.min_value = 10
    }.should_not raise_error
  end

  it "has line datas" do
    velocitator = SingleVelocitator.new("haml-i18n-extractor", "0.0.17")
    velocitator.line_datas.size.should eq (velocitator.versions.size)
  end

end


describe MultipleVelocitator do
  before do
    @some_versions = ["0.0.17", "0.0.5","0.0.10"]
  end

  it "can initialize multiple versions" do
    velocitator = MultipleVelocitator.new("haml-i18n-extractor", @some_versions)
    velocitator.versions.should == @some_versions
  end

  it "holds the totals of the gem" do
    velocitator = MultipleVelocitator.new("haml-i18n-extractor", ["0.0.17"])
    velocitator.totals.first[:version_downloads].should eq 377
  end

  it "sets the earliest start range from to all of the versions info" do
    # some_versions.map{|v| GemData.new("haml-i18n-extractor").versions_built_at[v]}
    # => ["2013-06-16T00:00:00Z", "2013-03-22T00:00:00Z", "2013-05-06T00:00:00Z"]
    velocitator = MultipleVelocitator.new("haml-i18n-extractor", @some_versions)
    velocitator.effective_date_range.should eq ["2013-03-22T00:00:00Z", "2013-09-20T00:00:00Z"]
  end

  it "sets the max value to the max of all of versions" do
    velocitator = MultipleVelocitator.new("haml-i18n-extractor", @some_versions)
    velocitator.default_max_value.should eq 344
  end

  it "sets the max value to the max of all of versions" do
    velocitator = MultipleVelocitator.new("haml-i18n-extractor", @some_versions)
    velocitator.default_max_value.should eq 344
  end

  it "should set the line data to an array of versions.size with equal length which should be the max value of any one of them" do
    velocitator = MultipleVelocitator.new("haml-i18n-extractor", @some_versions)
    velocitator.line_datas.size.should == @some_versions.size
    # all of them should be the same size, padded with 0's if there is no download info
    velocitator.line_datas.map{|d| d.size }.uniq.size.should == 1
  end

  it "has a shortcut graph method" do
    velocitator = MultipleVelocitator.new("haml-i18n-extractor", @some_versions)
    file = velocitator.graph
    File.exist?(file).should be_true
  end
end

describe AggregatedVelocitator do
  before do
    @gem_name = "haml-i18n-extractor"
    @major_version = "0"
    @minor_version = "0.4"
  end

  it "can initialize and find out about all versions in a major" do
    velocitator = AggregatedVelocitator.new(@gem_name, @major_version)
    velocitator.aggregated_versions.should == ["0.5.9", "0.5.8", "0.5.6", "0.5.5", "0.5.4", "0.5.3", "0.5.2", "0.5.1", "0.5.0", "0.4.3", "0.4.2", "0.4.1", "0.4.0", "0.3.5", "0.3.4", "0.3.2", "0.3.0", "0.2.1", "0.2.0", "0.1.0", "0.0.21", "0.0.20", "0.0.19", "0.0.18", "0.0.17", "0.0.16", "0.0.15", "0.0.12", "0.0.10", "0.0.9", "0.0.5"]
  end

  it "can initialize and find out about all versions in specific a minor" do
    velocitator = AggregatedVelocitator.new(@gem_name, @minor_version)
    velocitator.aggregated_versions.should == ["0.4.3", "0.4.2", "0.4.1", "0.4.0"]
  end

  it "sends the first and last version passed as versions though" do
    velocitator = AggregatedVelocitator.new(@gem_name, @minor_version)
    velocitator.versions = ["0.4.3","0.4.0"]
  end

  it "sends only one graph that is the total of those versions" do
    velocitator = AggregatedVelocitator.new(@gem_name, @minor_version)
    velocitator.line_datas.first.size == 1 # [[1,2,3]] but not [[1,2,3][1,4,8]]
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
