# GeoQuery

Saves you the hassle of writing your own location queries and uses pre-built and reusable methods.

The current version only supports Rails **4.2+**. Request other versions by opening an issue.

##Install
*These instructions already assume you have postgis enabled on your database, please follow the instructions here to enabled it https://github.com/rgeo/activerecord-postgis-adapter#install*

**Include gem**
```ruby
gem 'geo_query'
```
**Generate the migration**

*Will add a geography field to your model (Skip if already exists)*
```ruby
# Where user is your model name
rails g geo_query:resource User
```
**Attach the helper to your model**
```ruby
class User < ActiveRecord::Base
  # location column defaults to :coordinates
  geo_queryable column: :coordinates
end
```

##Usage
The helper gives your model the following methods

**Instance Methods**
```ruby
# Returns nearest objects
object.near(radius)
```
**Class Methods**
```ruby
# Returns all objects within the specified radius ordered by nearest
Class.near_lat_lon(lat, lon, radius) #radius defaults to 500metres
```
```ruby
# Returns all objects within a rectangle
Class.within_bounding_box(min_lat, min_lon, max_lat, max_lon)
```
**Attribute setters**
```ruby
User.create(lat: -38, lon: 144)
```

*More coming soon...*
