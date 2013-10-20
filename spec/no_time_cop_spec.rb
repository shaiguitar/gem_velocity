require 'spec_helper'

describe 'with no time stubbing', :do_not_use_time_cop do

  # hax slow internet connections make this slow.
  if ENV['VELOCITATOR_REAL_LONG']
    it "has a shortcut graph method #1" do
      velocitator = SingleVelocitator.new("rails", "2.3.5")
      # WTF all is shit
      # https://rubygems.org/gems/rails/versions/2.3.5
      # should be close to 1m!!
      #
      # gb = velocitator.send(:gruff_builder)
      # gb.line_datas.first.index{|z| z.nonzero?}
      # => 1199
      # gb.line_datas.first.size #[1199]
      # => 1417
      # 1417 - 1199
      # => 218
      #
      # velocitator.send(:gem_data).send(:downloads_metadata, velocitator.versions.first,velocitator.effective_date_range.first, velocitator.effective_date_range.last).size
      # => 1417
      # velocitator.send(:gem_data).downloads_day(velocitator.versions.first,velocitator.effective_date_range.first, velocitator.effective_date_range.last).size
      # => 218
      # x = Gems.downloads(velocitator.gem_name, velocitator.versions.first, velocitator.effective_date_range.first, velocitator.effective_date_range.last)
      # x.to_a.index{|z| z.last.nonzero?}
      # => 1198
      #x.to_a.index{|z| z.last.nonzero?}
      # FIXME . got local dump of database
      #binding.pry
     velocitator = SingleVelocitator.new("rails", "2.3.5")
      file = velocitator.graph("/tmp")
    end

    it "has a shortcut graph method #2" do
      velocitator = MultipleVelocitator.new("rails", ["4.0.0","3.2.14","0.9.1"])
      file = velocitator.graph("/tmp", [3.months.ago, Time.now])
      File.exist?(file).should be_true
    end

    it "has a shortcut graph method #3" do
      velocitator = AggregatedVelocitator.new("rails", "4")
      puts velocitator.versions
      puts velocitator.totals.inspect
      file = velocitator.graph("/tmp")
      File.exist?(file).should be_true
    end

    it "has a shortcut graph method #4" do
      velocitator = AggregatedVelocitator.new("haml-i18n-extractor", "0") # all of it
      puts velocitator.aggregated_versions
      puts velocitator.versions
      file = velocitator.graph("/tmp")
      puts file.inspect
      File.exist?(file).should be_true
    end
  end

end

