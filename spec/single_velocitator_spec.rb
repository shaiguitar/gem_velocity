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
    velocitator.graph_options[:labels].should == ({1=>"2013-09-13", (velocitator.line_data.size-2) =>"2013-09-17"})
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
    velocitator.totals_map_by_version["0.0.17"][:version_downloads].should eq 377
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

  it "has line data" do
    velocitator = SingleVelocitator.new("haml-i18n-extractor", "0.0.17")
    velocitator.line_data.should_not be_empty # [1,2,3]
  end
end


