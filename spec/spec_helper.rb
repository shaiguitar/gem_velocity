require 'gem_velocity'
require 'pry'
require 'vcr'
require 'sourcify'
require 'active_support/all' # time
require 'timecop'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  c.hook_into :webmock # or :fakeweb
  c.default_cassette_options = { :record => :new_episodes }
end

module SpecHelper
  def self.tmpdir
    File.expand_path File.join(File.dirname(__FILE__), "tmp")
  end
end

RSpec.configure do |c|
  c.treat_symbols_as_metadata_keys_with_true_values = true

  c.around(:each) do |example|
    example_hashified = example.metadata[:description_args].first.unpack("s").first
    puts "\nRunning example: #{example.metadata[:description_args]}\n"
    orig_time = Time.now
    VCR.use_cassette("rspec-example-#{(example_hashified)}") do
      example.run
    end
    puts "finished in ~#{Time.now.to_i - orig_time.to_i}s"
  end

  c.around(:each) do |example|
    #freeze time unless explicitly said not to!
    unless example.metadata[:do_not_use_time_cop]
      Timecop.travel(Time.local(2013, 9, 20, 10, 0, 0))
      Timecop.freeze
    end
    example.run
    unless example.metadata[:do_not_use_time_cop]
      Timecop.return
    end
  end

  c.after(:suite) do
    FileUtils.rm_rf(SpecHelper.tmpdir)
  end
end

