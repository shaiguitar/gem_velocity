require 'spec_helper'

describe Velocitator do

  before do
    Timecop.travel(Time.local(2013, 9, 20, 10, 0, 0))
    # the 10: flattens out to 00: but we don't care at this point as it's day by day.
    Timecop.freeze
  end

  it 'raises if you dont pass name and version' do
    lambda { Velocitator.new(nil,nil) }.should raise_error ArgumentError
  end

  it "sets a specific date range according to the gem's info" do
    VCR.use_cassette('velocitator-haml-i18n-extractor-0.5.8-versions-info') do
      velocitator = Velocitator.new("haml-i18n-extractor", "0.5.8")
      # 1.year.ago is truncated down, because the first download was at...also, end time is :now.
      velocitator.effective_date_range.should eq ["2013-09-15T00:00:00Z", "2013-09-20T00:00:00Z"]
    end
  end

  it "can override the default time ranges if its in the range" do
    VCR.use_cassette('velocitator-haml-i18n-extractor-0.5.8-versions-override') do
      velocitator = Velocitator.new("haml-i18n-extractor", "0.5.8")
      # 1.year.ago is truncated down, because the first download was at...also, end time is :now.
      velocitator.date_range = [1.day.ago, Time.now]
      velocitator.effective_date_range.should eq ["2013-09-19T00:00:00Z", "2013-09-20T00:00:00Z"]
      velocitator.line_data.size.should eq (velocitator.specific_days_in_range.size)
    end
  end

  it "can set a max and min" do
    VCR.use_cassette('velocitator-haml-i18n-extractor-0.5.8-versions') do
      velocitator = Velocitator.new("haml-i18n-extractor", "0.5.8")
      lambda {
        velocitator.max_value = 500
        velocitator.min_value = 10
      }.should_not raise_error
    end
  end

  it "can render a graph" do
    VCR.use_cassette('velocitator-haml-i18n-extractor-0.5.8-versions-graph') do
      velocitator = Velocitator.new("haml-i18n-extractor", "0.5.8")
      velocitator.date_range = [1.day.ago, Time.now]
      velocitator.root = SpecHelper.tmpdir
      builder = velocitator.gruff_builder

      # fixture / webmock / data etc.. if it fails, rm -rf spec/fixtures/vcr_cassettes
      builder.line_data.should == [40, 42]
      builder.title.should == "haml-i18n-extractor-0.5.8"
      builder.labels.should == ({1=>"2013-09-19", (builder.line_data.size-2) =>"2013-09-20"})
      builder.max_value.should == 77
      builder.min_value.should == 0

      file = builder.write
      File.exist?(file).should be_true
      #`open #{file} -a preview.app`
      #Kernel.sleep(10)
    end
  end

  it "has a shortcut graph method" do
    VCR.use_cassette('velocitator-haml-i18n-extractor-0.5.8-graph-shortcut') do
      velocitator = Velocitator.new("haml-i18n-extractor", "0.5.8")
      # api is: graph(root,range,max,min). passing nil passses defaults.
      # move these to individual tests?
      file = velocitator.graph(SpecHelper.tmpdir,[1.day.ago, Time.now])
      file = velocitator.graph
      file = velocitator.graph(nil,nil,0,1000)
      File.exist?(file).should be_true
    end
  end

end

