require 'spec_helper'

describe 'with no time stubbing', :do_not_use_time_cop do

  # hax slow internet connections make this slow.
  if ENV['VELOCITATOR_REAL_LONG']
    it "has a shortcut graph method #1" do
      v = velocitator = SingleVelocitator.new("rails", "2.3.5")
      # https://rubygems.org/gems/rails/versions/2.3.5
      # should be close to 1m, but the total from thei api returned is ~300k.
      # between 2013-03-07 and 2013-03-08 it "starts". but there's a ton of missing data from rubygems.
      #
      # v.send(:gem_data).downloads_metadata(v.version, v.send(:effective_start_time), v.send(:effective_end_time))
      # _.map(&:last).sum
      #
      # FIXME https://github.com/rubygems/rubygems.org/pull/606 has the method under test which is busted in reality.
      file = velocitator.graph("/tmp")
    end

    it "has a shortcut graph method #2" do
      velocitator = MultipleVelocitator.new("rails", ["4.0.0","3.2.14","0.9.1"])
      file = velocitator.graph("/tmp", [3.months.ago, Time.now])
      File.exist?(file).should be_true
    end

    it "has a shortcut graph method #3" do
      velocitator = AggregatedVelocitator.new("rails", "4")
      #puts velocitator.versions
      #puts velocitator.totals.inspect
      file = velocitator.graph("/tmp")
      File.exist?(file).should be_true
    end

    it "has a shortcut graph method #4" do
      velocitator = AggregatedVelocitator.new("haml-i18n-extractor", "0") # all of it
      #puts velocitator.aggregated_versions
      #puts velocitator.versions
      file = velocitator.graph("/tmp")
      #puts file.inspect
      File.exist?(file).should be_true
    end
  end

end

