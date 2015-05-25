require 'spec_helper'

describe User do
  before :each do
    User.class_eval do
      geo_queryable :coordinates
    end
  end

  it "valid geo_queryable function" do

  end

end
