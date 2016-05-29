# Clean an replace the DB.
rm db/schema.rb
rm db/development.sqlite3
#cp db/development.sqlite3.with_cities_and_cars db/development.sqlite3

# Run new migrations
rake db:migrate

# Seed new data into the DB
rake db:seed

# Open Database for exploration
open ./db/development.sqlite3
