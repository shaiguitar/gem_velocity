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
  c.around(:each) do |example|
    example_hashified = example.metadata[:description_args].first.unpack("s").first
    puts "\nRunning example: #{example.metadata[:description_args]}\n"
    VCR.use_cassette("rspec-example-#{(example_hashified)}") do
      example.run
    end
  end

  c.after(:suite) do
    FileUtils.rm_rf(SpecHelper.tmpdir)
  end
end

