require 'spec_helper'

describe Velocitator do

  before do
    # for Time.now
    # Also, the 10 mins flattens out to 00: but we don't care at this point as it's day by day.
    Timecop.travel(Time.local(2013, 9, 20, 10, 0, 0))
    Timecop.freeze
  end

  after do
    Timecop.return
  end

  it 'raises if you dont pass name and version(s)' do
    lambda { Velocitator.new(nil,nil) }.should raise_error ArgumentError
  end

  describe "a specific version" do
    it "sets a specific date range according to the gem's info" do
      VCR.use_cassette('velocitator-haml-i18n-extractor-0.0.17-versions-info') do
        velocitator = Velocitator.new("haml-i18n-extractor", "0.0.17")
        velocitator.effective_date_range.should eq ["2013-06-16T00:00:00Z", "2013-09-20T00:00:00Z"]
      end
    end

    it "can override the default time ranges if its in the range" do
      VCR.use_cassette('velocitator-haml-i18n-extractor-0.0.17-versions-override') do
        velocitator = Velocitator.new("haml-i18n-extractor", "0.0.17")
        velocitator.date_range = [1.day.ago, Time.now]
        velocitator.effective_date_range.should eq ["2013-09-19T00:00:00Z", "2013-09-20T00:00:00Z"]
        velocitator.line_datas.size.should eq (velocitator.versions.size)
      end
    end

    it "can set a max and min" do
      VCR.use_cassette('velocitator-haml-i18n-extractor-0.0.17-versions') do
        velocitator = Velocitator.new("haml-i18n-extractor", "0.0.17")
        lambda {
          velocitator.max_value = 500
          velocitator.min_value = 10
        }.should_not raise_error
      end
    end

    it "can render a graph" do
      VCR.use_cassette('velocitator-haml-i18n-extractor-0.0.17-versions-graph') do
        velocitator = Velocitator.new("haml-i18n-extractor", "0.0.17")
        velocitator.date_range = [1.day.ago, Time.now]
        velocitator.root = SpecHelper.tmpdir
        builder = velocitator.gruff_builder

        # fixture / webmock / data etc.. if it fails, rm -rf spec/fixtures/vcr_cassettes
        builder.line_datas.should == [[75,76]]
        builder.title.should == "haml-i18n-extractor-0.0.17"
        builder.labels.should == ({1=>"2013-09-19", (builder.line_datas.first.size-2) =>"2013-09-20"})
        builder.max_value.should == 95
        builder.min_value.should == 0

        file = builder.write
        File.exist?(file).should be_true
        #`open #{file} -a preview.app`
        #Kernel.sleep(10)
      end
    end

    it "has a shortcut graph method #1" do
      VCR.use_cassette('velocitator-haml-i18n-extractor-0.0.17-graph-shortcut-1') do
        velocitator = Velocitator.new("haml-i18n-extractor", "0.0.17")
        file = velocitator.graph(SpecHelper.tmpdir,[1.day.ago, Time.now])
        File.exist?(file).should be_true
      end
    end

    it "has a shortcut graph method #2" do
      VCR.use_cassette('velocitator-haml-i18n-extractor-0.0.17-graph-shortcut-2') do
        velocitator = Velocitator.new("haml-i18n-extractor", "0.0.17")
        file = velocitator.graph
        File.exist?(file).should be_true
      end
    end

    it "has a shortcut graph metho #3" do
      VCR.use_cassette('velocitator-haml-i18n-extractor-0.0.17-graph-shortcut-3') do
        velocitator = Velocitator.new("haml-i18n-extractor", "0.0.17")
       file = velocitator.graph(nil,nil,0,1000)
        File.exist?(file).should be_true
      end
    end

  end

  describe "Multiple versions" do
    before do 
      @some_versions = ["0.0.17", "0.0.5","0.0.10"]
      Timecop.travel(Time.local(2013, 9, 20, 10, 0, 0))
      Timecop.freeze

    end

    after do
      Timecop.return
    end


    it "can initialize multiple versions" do
      VCR.use_cassette('velocitator-haml-i18n-extractor-multiple-versions') do
        velocitator = Velocitator.new("haml-i18n-extractor", @some_versions)
        velocitator.versions.should == @some_versions
      end
    end

    it "sets the earliest start range from to all of the versions info" do
      VCR.use_cassette('velocitator-haml-i18n-extractor-0.0.17-multiple-versions-info') do
        # some_versions.map{|v| GemData.new("haml-i18n-extractor").versions_built_at[v]}
        # => ["2013-06-16T00:00:00Z", "2013-03-22T00:00:00Z", "2013-05-06T00:00:00Z"]
        velocitator = Velocitator.new("haml-i18n-extractor", @some_versions)
        velocitator.effective_date_range.should eq ["2013-03-22T00:00:00Z", "2013-09-20T00:00:00Z"]
      end
    end

    it "sets the max value to the max of all of versions" do
      VCR.use_cassette('velocitator-haml-i18n-extractor-0.0.17-multiple-versions-max-value') do
        velocitator = Velocitator.new("haml-i18n-extractor", @some_versions)
        velocitator.default_max_value.should eq 95
      end
    end

    it "sets the max value to the max of all of versions" do
      VCR.use_cassette('velocitator-haml-i18n-extractor-0.0.17-multiple-versions-max-value') do
        velocitator = Velocitator.new("haml-i18n-extractor", @some_versions)
        velocitator.default_max_value.should eq 95
      end
    end

    it "should set the line data to an array of versions.size with equal length which should be the max value of any one of them" do
      VCR.use_cassette('velocitator-haml-i18n-extractor-0.0.17-multiple-versions-line-data') do
        velocitator = Velocitator.new("haml-i18n-extractor", @some_versions)
        velocitator.line_datas.size.should == @some_versions.size
        # all of them should be the same size, padded with 0's if there is no download info
        velocitator.line_datas.map{|d| d.size }.uniq.size.should == 1
      end
    end

    it "has a shortcut graph method" do
      VCR.use_cassette('velocitator-haml-i18n-extractor-multiple-graph-shortcut') do
        velocitator = Velocitator.new("haml-i18n-extractor", @some_versions)
        file = velocitator.graph
        puts file.inspect
        File.exist?(file).should be_true
      end
    end
  end


end

