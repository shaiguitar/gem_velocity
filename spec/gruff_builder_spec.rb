require 'spec_helper'

describe GruffBuilder do
  before do
    @tmp_dir = SpecHelper.tmpdir
  end

  it "raises if no root or if versions isnt an array" do
    lambda { builder = GruffBuilder.new(nil,nil,nil,nil, {}) }.should raise_error
  end

  it "has defaults" do
    builder = GruffBuilder.new(@tmp_dir,nil,[],nil, {})
    builder.root = @tmp_dir
    builder.relative_path = "images/"
    builder.versions = []
    builder.gem_name = nil

    builder.title = ""
    builder.labels = {}
    builder.line_datas = nil
    builder.min_value = 0
    builder.max_value = 300
  end

  it "has a filename" do
    builder = GruffBuilder.new(@tmp_dir,nil,["0.0.17"],"foo-baz", {})
    builder.relative_filename.should eq "public/images/foo-baz-0.0.17.png"
  end

  it "can not write a file if there is no line data" do
    builder = GruffBuilder.new(@tmp_dir,nil,["0.0.17"],"foo-baz", {})
    lambda { builder.write }.should raise_error GruffBuilder::NoData
  end

  it "can write out a file" do
    builder = GruffBuilder.new(@tmp_dir,nil,["0.0.17"],"foo-baz", {})
    builder.line_datas = [1,2,3]
    builder.write
    file = builder.absolute_filename
    File.exists?(file).should be_true
  end

  it "can write out a file with gruff data" do
    gruff_options = {
      :title => "A pickture",
      :labels => {1 => "label", 3 => "label2"},
      :line_datas => [1,2,3,10,8,12],
      :min_value => 0,
      :max_value => 20,
    }
    builder = GruffBuilder.new(@tmp_dir,nil,["0.0.17"],"foo-baz", gruff_options)
    builder.write
    file = builder.absolute_filename
    File.exists?(file).should be_true
  end

end

