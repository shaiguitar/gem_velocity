require 'gem_velocity'
require 'pry'
require 'vcr'
require 'active_support/all' # time
require 'timecop'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  c.hook_into :webmock # or :fakeweb
end

module SpecHelper
  def self.tmpdir
    File.expand_path File.join(File.dirname(__FILE__), "tmp")
  end
end

RSpec.configure do |c|
  c.after(:suite) do
    FileUtils.rm_rf(SpecHelper.tmpdir)
  end
end

