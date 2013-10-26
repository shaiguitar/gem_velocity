require 'spec_helper'

# TODO this spec duplicates a lot of the velocitator specs?
# refactor this spec in conjunction with velocitator_spec
# also, probably should refactor multiplexer to inherit from base_velocitator
# instead of being it's own thing.

describe Multiplexer do
  before do
    # single
    @v1 = BaseVelocitator.create(:gem_name => "haml-i18n-extractor", :version => "0.0.17")
    @v2 = BaseVelocitator.create(:gem_name => "haml-i18n-extractor", :version => "0.0.16")
    # aggregate
    @v3 = BaseVelocitator.create(:gem_name => "haml-i18n-extractor", :version => "0.4.x")
    @velocitators = [@v1,@v2,@v3]
    @multiplexer = Multiplexer.new(@velocitators)
  end

  it "initializes with velocitators" do
    @multiplexer = Multiplexer.new(@velocitators)
    @multiplexer.velocitators.should == [@v1,@v2,@v3]
  end

  it "keeps the line_datas of each velocitator" do
    @multiplexer.graph_options[:line_datas].size.should eq 3
    ld3 = @multiplexer.graph_options[:line_datas].last
    @v3.line_data.each {|total|
      ld3.include?(total).should be_true
    }
  end

  it "keeps line datas aligned with time" do
    # could be a better test here (time factored in)
    @multiplexer.graph_options[:line_datas].map(&:size).sort.uniq.size.should == 1 # all of them should be the same size (padded with 0's)...
  end

  it "start time is the earliest date of them all" do
    @velocitators.each { |v|
      v.effective_start_time.should >= @multiplexer.effective_start_time
    }
  end

  it "end time is the latest" do
    @velocitators.each { |v|
      v.effective_end_time.should <= @multiplexer.effective_end_time
    }
  end

  it "defines the largest max" do
    @velocitators.each { |v|
      v.effective_max_value <= @multiplexer.effective_max_value
    }
  end

  it "smallest minimum" do
    @velocitators.each { |v|
      v.effective_min_value >= @multiplexer.effective_min_value
    }
  end

  # FIXME
  it "sets the root according to the first velocitators root it finds or cwd otherwise" do
    @multiplexer.root.should == Dir.pwd
    @v1.root = @tmp_dir
    @multiplexer.root.should eq @tmp_dir
  end

  it "can draw a graph" do
    file = @multiplexer.graph
    puts file.inspect
  end
end

