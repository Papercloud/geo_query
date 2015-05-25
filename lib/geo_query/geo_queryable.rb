module GeoQuery
  module GeoQueryable
    extend ActiveSupport::Concern

    included do
      # Class vars
      mattr_accessor :point_column
      @@point_column = nil

      # Validations
      before_validation :save_coordinates

      attr_accessor :lat, :lng

      # Instance Methods
      def save_coordinates
        if lat.present? && lng.present?
          self.coordinates = "POINT(#{lng} #{lat})"
        end
      end

      # Class methods
      ## Returns other objects within the given radius of a point
      def self.near_lat_lng(lat, lng, radius=500) #radius in metres
        select("#{self.base_class.table_name}.*, ST_Distance(#{self.base_class.point_column}, ST_GeographyFromText('POINT(#{lng} #{lat})')) AS distance")
        .where("ST_DWithin(#{self.base_class.point_column} , ST_GeographyFromText('POINT(#{lng} #{lat})'), #{radius})")
        .order("distance ASC")
      end

      ## Returns all objects within a bounding box
      def self.within_bounding_box(min_lat, min_lng, max_lat, max_lng)
        select("#{self.base_class.table_name}.*").
        where("#{self.base_class.point_column} && ST_MakeEnvelope(?, ?, ?, ?, 4326)",
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