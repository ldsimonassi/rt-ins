rake db:drop
rm db/schema.rb
rake db:migrate
rake db:seed
open ./db/development.sqlite3
