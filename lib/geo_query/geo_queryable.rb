module GeoQuery
  module GeoQueryable
    extend ActiveSupport::Concern

    included do

    end

    module ClassMethods
      def geo_queryable(options = {})
        #initialize
      end
    end
  end
end