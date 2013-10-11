require 'spec_helper'

describe 'with no time stubbing', :do_not_use_time_cop do

  # hax slow internet connections make this slow.
  if ENV['VELOCITATOR_REAL_LONG']
    it "has a shortcut graph method #1" do
      velocitator = Velocitator.new("rails", ["4.0.0","3.2.14","2.3.5"])
      file = velocitator.graph("/tmp")
      File.exist?(file).should be_true
    end

    it "has a shortcut graph method #2" do
      velocitator = Velocitator.new("rails", ["4.0.0","3.2.14","0.9.1"])
      file = velocitator.graph("/tmp", [3.months.ago, Time.now])
      File.exist?(file).should be_true
    end
  end

end

