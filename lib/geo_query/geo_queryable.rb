module GeoQuery
  module GeoQueryable
    extend ActiveSupport::Concern

    included do
      # Class vars
      mattr_accessor :point_column
      @@point_column = nil

      attr_accessor :lat, :lng

      # Validations
      validate :save_coordinates

      def save_coordinates
        if lat.present? && lng.present?
          self.coordinates = "POINT(#{lng} #{lat})"
        elsif (lat.present? && lng.blank?) || (lng.present? && lat.blank?)
          errors.add(self.point_column, "requires both latitude and longitude")
        end
      end

      # Instance Methods
      def rgeo_factory
        RGeo::Geographic.spherical_factory(:srid => 4326)
      end

      def near(radius=500) #radius in metres
        # x = longitude && y = latitude
        return User.near_lat_lng(st_coordinates.y, st_coordinates.x, radius) if st_coordinates
        self.class.none
      end

      def st_coordinates
        send("#{self.point_column}")
      end

      # Class methods
      ## Returns other objects within the given radius of a point
      def self.near_lat_lng(lat, lng, radius=500) #radius in metres
        select("#{self.table_name}.*, ST_Distance(#{self.point_column}, ST_GeographyFromText('POINT(#{lng} #{lat})')) AS distance")
        .where("ST_DWithin(#{self.point_column} , ST_GeographyFromText('POINT(#{lng} #{lat})'), #{radius})")
        .order("distance ASC")
      end

      ## Returns all objects within a bounding box
      def self.within_bounding_box(min_lat, min_lng, max_lat, max_lng)
        select("#{self.table_name}.*").
        where("#{self.point_column} && ST_MakeEnvelope(?, ?, ?, ?, 4326)",
          min_lng, min_lat, max_lng, max_lat)
      end

    end

    module ClassMethods
      # Init method
      def geo_queryable(options = {})
        self.base_class.point_column = options[:coordinates] || :coordinates
      end
    end
  end
end