$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "geo_query/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "geo_query"
  s.version     = GeoQuery::VERSION
  s.authors     = ["William Porter"]
  s.email       = ["wp@papercloud.com.au"]
  s.homepage    = "http://papercloud.com.au"
  s.summary     = "Query PostGIS coordinate objects on any model"
  s.description = "Saves you the hassle of writing your own location queries and uses pre-built and reusable methods."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 4.2"
  s.add_dependency 'activerecord-postgis-adapter', '3.0.0.beta5'

  s.add_development_dependency "pg"
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'factory_girl_rails'
  s.add_development_dependency 'awesome_print'

end
