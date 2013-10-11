require 'spec_helper'

describe Velocitator do

  it 'raises if you dont pass name and version(s)' do
    lambda { Velocitator.new(nil,nil) }.should raise_error ArgumentError
  end

  it 'raises if the gem is not found' do
    lambda { Velocitator.new("NOSICHGEMPlZ123","0.1") }.should raise_error NoSuchGem
  end

  it 'raises if the version is not found' do
    # cause the .pre matters!!1
    lambda { Velocitator.new("haml-i18n-extractor","100.999.42.666.pre") }.should raise_error NoSuchVersion
  end

 describe "a specific version" do

    it "sets a specific date range according to the gem's info" do
      velocitator = Velocitator.new("haml-i18n-extractor", "0.0.17")
      velocitator.effective_date_range.should eq ["2013-06-16T00:00:00Z", "2013-09-20T00:00:00Z"]
    end

    it "can override the default time ranges if its in the range" do
      velocitator = Velocitator.new("haml-i18n-extractor", "0.0.17")
      velocitator.date_range = [1.day.ago, Time.now]
      velocitator.effective_date_range.should eq ["2013-09-19T00:00:00Z", "2013-09-20T00:00:00Z"]
      velocitator.line_datas.size.should eq (velocitator.versions.size)
    end

    it "can set a max and min" do
      velocitator = Velocitator.new("haml-i18n-extractor", "0.0.17")
      lambda {
        velocitator.max_value = 500
        velocitator.min_value = 10
      }.should_not raise_error
    end

    it "can render a graph" do
      velocitator = Velocitator.new("haml-i18n-extractor", "0.0.17")
      velocitator.date_range = [1.day.ago, Time.now]
      velocitator.root = SpecHelper.tmpdir
      builder = velocitator.gruff_builder

      # FIXME
      # also, pending on issue relating to
      # https://github.com/shaiguitar/rubygems.org/compare/api_not_returning_all_results_over_90_days?expand=1
      builder.line_datas.should == [[343, 344]]
      builder.title.should == "haml-i18n-extractor-0.0.17"
      builder.labels.should == ({1=>"2013-09-19", (builder.line_datas.first.size-2) =>"2013-09-20"})
      builder.max_value.should == 344
      builder.min_value.should == 0

      file = builder.write
      File.exist?(file).should be_true
      #`open #{file} -a preview.app`
      #Kernel.sleep(10)
    end

    it "has a shortcut graph method #1" do
      velocitator = Velocitator.new("haml-i18n-extractor", "0.0.17")
      file = velocitator.graph(SpecHelper.tmpdir,[1.day.ago, Time.now])
      File.exist?(file).should be_true
    end

    it "has a shortcut graph method #2" do
      velocitator = Velocitator.new("haml-i18n-extractor", "0.0.17")
      file = velocitator.graph
      File.exist?(file).should be_true
    end

    it "has a shortcut graph metho #3" do
      velocitator = Velocitator.new("haml-i18n-extractor", "0.0.17")
      file = velocitator.graph(nil,nil,0,1000)
      File.exist?(file).should be_true
    end

  end

  describe "Multiple versions" do
    before do 
      @some_versions = ["0.0.17", "0.0.5","0.0.10"]
    end

    it "can initialize multiple versions" do
      velocitator = Velocitator.new("haml-i18n-extractor", @some_versions)
      velocitator.versions.should == @some_versions
    end

    it "sets the earliest start range from to all of the versions info" do
      # some_versions.map{|v| GemData.new("haml-i18n-extractor").versions_built_at[v]}
      # => ["2013-06-16T00:00:00Z", "2013-03-22T00:00:00Z", "2013-05-06T00:00:00Z"]
      velocitator = Velocitator.new("haml-i18n-extractor", @some_versions)
      velocitator.effective_date_range.should eq ["2013-03-22T00:00:00Z", "2013-09-20T00:00:00Z"]
    end

    it "sets the max value to the max of all of versions" do
      velocitator = Velocitator.new("haml-i18n-extractor", @some_versions)
      velocitator.default_max_value.should eq 344
    end

    it "sets the max value to the max of all of versions" do
      velocitator = Velocitator.new("haml-i18n-extractor", @some_versions)
      velocitator.default_max_value.should eq 344
    end

    it "should set the line data to an array of versions.size with equal length which should be the max value of any one of them" do
      velocitator = Velocitator.new("haml-i18n-extractor", @some_versions)
      velocitator.line_datas.size.should == @some_versions.size
      # all of them should be the same size, padded with 0's if there is no download info
      velocitator.line_datas.map{|d| d.size }.uniq.size.should == 1
    end

    it "has a shortcut graph method" do
      velocitator = Velocitator.new("haml-i18n-extractor", @some_versions)
      file = velocitator.graph
      File.exist?(file).should be_true
    end
  end


end

