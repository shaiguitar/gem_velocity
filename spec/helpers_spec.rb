require 'spec_helper' 

class Whatever
  extend Helpers
end

describe Helpers do

  it "can format date" do
    date = Date.parse("2013-09-15")
    Whatever.time_format_str(date).should eq "2013-09-15T00:00:00Z"
  end

  it "can format str" do
    date = "2013-09-15"
    Whatever.time_format_str(date).should eq "2013-09-15T00:00:00Z"
  end

end
