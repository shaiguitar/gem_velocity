require 'spec_helper'

describe GemData do
  it "collects version info for a given gem" do
    GemData.new("haml-i18n-extractor").versions.should include "0.0.17"
  end

  it "maps built_at and versions for access" do
    GemData.new("haml-i18n-extractor").versions_built_at["0.0.17"].should == "2013-06-16T00:00:00Z"
  end

  it "can show download information" do
    gem_data = GemData.new("haml-i18n-extractor")
    gem_data.parallel_fetch_for(["0.0.17"])
    result = gem_data.prefetched_downloads_metadata("0.0.17", gem_data.versions_built_at["0.0.17"],Time.now).to_a
    result.should == [["2013-06-16", 38], ["2013-06-17", 16], ["2013-06-18", 3], ["2013-06-19", 1], ["2013-06-20", 4], ["2013-06-21", 1], ["2013-06-22", 5], ["2013-06-23", 2], ["2013-06-24", 3], ["2013-06-25", 9], ["2013-06-26", 161], ["2013-06-27", 3], ["2013-06-28", 2], ["2013-06-29", 0], ["2013-06-30", 0], ["2013-07-01", 0], ["2013-07-02", 7], ["2013-07-03", 3], ["2013-07-04", 2], ["2013-07-05", 0], ["2013-07-06", 3], ["2013-07-07", 0], ["2013-07-08", 2], ["2013-07-09", 1], ["2013-07-10", 2], ["2013-07-11", 3], ["2013-07-12", 2], ["2013-07-13", 1], ["2013-07-14", 0], ["2013-07-15", 2], ["2013-07-16", 2], ["2013-07-17", 6], ["2013-07-18", 0], ["2013-07-19", 3], ["2013-07-20", 1], ["2013-07-21", 0], ["2013-07-22", 2], ["2013-07-23", 1], ["2013-07-24", 6], ["2013-07-25", 0], ["2013-07-26", 0], ["2013-07-27", 0], ["2013-07-28", 0], ["2013-07-29", 1], ["2013-07-30", 2], ["2013-07-31", 2], ["2013-08-01", 0], ["2013-08-02", 0], ["2013-08-03", 0], ["2013-08-04", 0], ["2013-08-05", 2], ["2013-08-06", 0], ["2013-08-07", 0], ["2013-08-08", 3], ["2013-08-09", 0], ["2013-08-10", 0], ["2013-08-11", 0], ["2013-08-12", 1], ["2013-08-13", 2], ["2013-08-14", 1], ["2013-08-15", 2], ["2013-08-16", 0], ["2013-08-17", 1], ["2013-08-18", 0], ["2013-08-19", 0], ["2013-08-20", 0], ["2013-08-21", 1], ["2013-08-22", 2], ["2013-08-23", 4], ["2013-08-24", 0], ["2013-08-25", 1], ["2013-08-26", 0], ["2013-08-27", 2], ["2013-08-28", 0], ["2013-08-29", 2], ["2013-08-30", 0], ["2013-08-31", 0], ["2013-09-01", 2], ["2013-09-02", 2], ["2013-09-03", 1], ["2013-09-04", 0], ["2013-09-05", 2], ["2013-09-06", 2], ["2013-09-07", 0], ["2013-09-08", 0], ["2013-09-09", 1], ["2013-09-10", 0], ["2013-09-11", 0], ["2013-09-12", 5], ["2013-09-13", 0], ["2013-09-14", 0], ["2013-09-15", 0], ["2013-09-16", 1], ["2013-09-17", 0], ["2013-09-18", 0], ["2013-09-19", 1], ["2013-09-20", 1]]
  end


end

