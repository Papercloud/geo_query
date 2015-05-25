require "geo_query/engine"

module GeoQuery
  extend ActiveSupport::Autoload
  autoload :GeoQueryable, 'geo_query/geo_queryable'


end

module ActiveRecord
  class Base
    include GeoQuery::GeoQueryable
  end
end