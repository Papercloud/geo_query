require 'rails/generators/active_record'

class GeoQuery::ResourceGenerator < Rails::Generators::NamedBase
  include Rails::Generators::Migration

  source_root File.expand_path('../templates', __FILE__)

  def copy_migrations
    copy_migration("add_coordinates_to", name.underscore)

    puts "added coordinates to #{name}"
    puts "rake db:migrate"
  end

  def self.next_migration_number(dirname)
    if ActiveRecord::Base.timestamped_migrations
      Time.now.utc.strftime("%Y%m%d%H%M%S")
    else
      "%.3d" % (current_migration_number(dirname) + 1)
    end
  end

  private

  def copy_migration(file, name)
    filename = "#{file}_#{name}"
    if self.class.migration_exists?("db/migrate", "#{filename}")
      say_status("skipped", "Migration #{filename}.rb already exists")
    else
      migration_template "#{file}.rb.erb", "db/migrate/#{filename}.rb"
    end
  end
end

