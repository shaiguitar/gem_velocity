require 'spec_helper'

describe "velocitator factory" do

  # pass in singles, or aggregated

  it "velocitator generation from name and version" do
    options = { gem_name: "haml-i18n-extractor", version: "0.0.17" }
    vg = Factory.new(options)
    vg.version.should == "0.0.17"
    vg.versions.should == ["0.0.17"]
    vg.gem_name.should =="haml-i18n-extractor"
  end

  it "velocitator generation from full name single" do
    options = { full_name: "haml-i18n-extractor-0.0.17" }
    vg = Factory.new(options)
    vg.version.should == "0.0.17"
    vg.versions.should == ["0.0.17"]
    vg.gem_name.should =="haml-i18n-extractor"
  end

  it "velocitator generation from full name aggregated" do
    options = { full_name: "haml-i18n-extractor-0.4.x" }
    vg = Factory.new(options)
    vg.version.should == "0.4.x"
    vg.versions.should == ["0.4.3", "0.4.2", "0.4.1", "0.4.0"]
    vg.gem_name.should =="haml-i18n-extractor"
  end

  it "velocitator generation from weird full name" do
    options = { full_name: "haml-i18n-extractor-0.0.17-dashes-mix-it-up" }
    lambda { 
      # would be this, but we're raising cause we're hitting rubygems
      vg = Factory.new(options)
      vg.version.should == "up"
      vg.versions.should == ["up"]
      vg.gem_name.should =="haml-i18n-extractor-0.0.17-dashes-mix-it"
    }.should raise_error(NoSuchGem)
  end

  it "is used in making velocitators from base single" do
    options = { gem_name: "haml-i18n-extractor", version: "0.0.17" }
    velocitator = BaseVelocitator.create(options)
    velocitator.class.should == SingleVelocitator
  end

  it "is used in making velocitators from base aggregated" do
    options = { gem_name: "haml-i18n-extractor", version: "0.4.x" }
    velocitator = BaseVelocitator.create(options)
    velocitator.class.should == AggregatedVelocitator
  end

end
