require 'spec_helper'

describe User do
  before :each do
    User.class_eval do
      geo_queryable column: :coordinates
    end
  end

  it "has valid factory" do
    user = build(:user)
    expect(user).to be_valid
  end

  describe "track updates" do
    before :each do
      User.class_eval do
        geo_queryable track_updates: true
      end
    end

    it "updates location_updated_at when coordinates change" do
      user = create(:user)
      expect{
        user.update(lat: 2, lon: 5)
      }.to change(user, :location_updated_at)
    end

  end

  ## Instance Methods
  describe "near" do
    before :each do
      @user = create(:user, coordinates: nil)
    end

    it "returns users if point_column present" do
      @user.update(lat: -37.809075, lon: 139.964770)
      expect(@user.near.length).to eq 1
    end

    it "returns empty association if point_column empty" do
      expect(@user.coordinates).to eq nil
      expect(@user.near.length).to eq 0
    end
  end

  ## Class Methods

  describe "self.near_lat_lon" do
    it "returns nearest user to a location" do
      user = create(:user, lat: -37.809075, lon: 139.964770)
      other_user = create(:user, lat: -37.809075, lon: 140)
      expect(User.near_lat_lon(-37.809075, 139.964770).first).to eq user
    end

    it "returns user within 50 meters from point" do
      user = create(:user, lat: -37.808695, lon: 144.966055)
      expect(User.near_lat_lon(-37.808617, 144.966317, 50)).to include user
    end

    it "doesn't return user thats greater than 50 minutes away" do
      user = create(:user, lat: -37.808695, lon: 144.966055)
      expect(User.near_lat_lon(-37.809401, 144.966370, 50)).to_not include user
    end
  end

  describe "self.within_geo_query_bounding_box" do

    it "returns user within bounding box" do
      user = create(:user, lat: 37.8117802, lon: 144.9651743)
      expect(User.within_geo_query_bounding_box(37.8117802, 144.9651743, 37.8117802, 144.9651743)).to include user
    end

    it "doesn't return user outside bounding box" do
      user = create(:user, lat: -37.8142383, lon: 144.9656678)
      expect(User.within_geo_query_bounding_box(37.8117802, 144.9651743, 37.8117802, 144.9651743)).to_not include user
    end
  end

end
