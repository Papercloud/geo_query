module GeoQuery
  module GeoQueryable
    extend ActiveSupport::Concern

    included do
      # Class vars
      mattr_accessor :point_column
      @@point_column = :coordinates

      mattr_accessor :track_updates
      @@track_updates = false

      # Accessors
      attr_accessor :lat, :lon

      def location_did_change?
        method("#{self.point_column}_changed?").call
      end

      def set_location_updated_at
        self.location_updated_at = Time.now
      end

      def save_coordinates
        if lat.present? && lon.present?
          self.coordinates = "POINT(#{lon} #{lat})"
        elsif (lat.present? && lon.blank?) || (lon.present? && lat.blank?)
          errors.add(self.point_column, "requires both latitude and longitude")
        end
      end

      # Instance Methods
      def rgeo_factory
        RGeo::Geographic.spherical_factory(:srid => 4326)
      end

      def near(radius=500) #radius in metres
        # x = longitude && y = latitude
        return self.class.near_lat_lon(st_coordinates.y, st_coordinates.x, radius) if st_coordinates
        self.class.none
      end

      def st_coordinates
        send("#{self.point_column}")
      end

      # Class methods
      ## Returns other objects within the given radius of a point
      def self.near_lat_lon(lat, lon, radius=500) #radius in metres
        select("#{self.table_name}.*, ST_Distance(#{self.point_column}, ST_GeographyFromText('POINT(#{lon} #{lat})')) AS distance")
        .where("ST_DWithin(#{self.table_name}.#{self.point_column} , ST_GeographyFromText('POINT(#{lon} #{lat})'), #{radius})")
        .order("distance ASC")
      end

      ## Returns all objects within a bounding box
      def self.within_geo_query_bounding_box(min_lat, min_lon, max_lat, max_lon)
        select("#{self.table_name}.*").
        where("#{self.table_name}.#{self.point_column} && ST_MakeEnvelope(?, ?, ?, ?, 4326)",
          min_lon, min_lat, max_lon, max_lat)
      end

    end

    module ClassMethods
      # Init method
      def geo_queryable(options = {})
        self.base_class.point_column  = options[:column] || :coordinates
        self.base_class.track_updates = options[:track_updates] || false

        # Validations
        validate :save_coordinates

        if self.base_class.track_updates

          # Callbacks
          before_save :set_location_updated_at, if: :location_did_change?
        end
      end
    end
  end
end
