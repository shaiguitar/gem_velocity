require 'spec_helper'

describe GemData do
  it "collects version info for a given gem" do
    VCR.use_cassette('gem-data-haml-i18n-extractor-0.5.8-versions') do
      GemData.new("haml-i18n-extractor").versions.should include "0.5.8"
    end
  end

  it "maps built_at and versions for access" do
    VCR.use_cassette('gem-data-haml-i18n-extractor-0.5.8-versions-built-at') do
      GemData.new("haml-i18n-extractor").versions_built_at["0.5.8"].should == "2013-09-15T00:00:00Z"
    end
  end

  it "can show download information" do
    VCR.use_cassette('gem-data-haml-i18n-extractor-0.5.8-downloads-day') do
      GemData.new("haml-i18n-extractor").downloads_day("0.5.8").should == [["2013-09-16", 32], ["2013-09-17", 36], ["2013-09-18", 37], ["2013-09-19", 40], ["2013-09-20", 42], ["2013-09-21", 44], ["2013-09-22", 45], ["2013-09-23", 45], ["2013-09-24", 47], ["2013-09-25", 53], ["2013-09-26", 63], ["2013-09-27", 66], ["2013-09-28", 68], ["2013-09-29", 69], ["2013-09-30", 74], ["2013-10-01", 74], ["2013-10-02", 74], ["2013-10-03", 74], ["2013-10-04", 77]]
    end
  end


end

