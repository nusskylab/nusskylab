* How to feed an SQL script via command line tools, in order to batch update the database?\
  Replace `script_name` with your own sql script name. Inside the sql script, you are free to write a series of sql commands.\
  `PGPASSWORD=nusskylab psql -U nusskylab nusskylab_dev -f script_name.sql`

* Is there any good online resource to learn Ruby on Rails for free?\
  The Odin Project is a good learning resource for beginners. The materials are accessible at:\
  https://www.theodinproject.com/\

* Encountered a issue when installing psql?\
  Please refer to `server_setup_guide.md` in this folder.\

* How to run tests?\
  Run `bundle exec bin/rake db:migrate RAILS_ENV=test` to prepare the database\
  Run `bundle exec rspec path/to/test_files` to run a particular test.\
  See rspec github page for more examples.\

* How do I see the existing routes?\
  See all the routes at: `http://localhost:3000/rails/info/routes`\

