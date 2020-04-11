#!/usr/bin/env bash
killall ruby
source ~/.bash_profile
rbenv shell 2.3.3
git checkout master
git pull
bundle install
RAILS_ENV=production bundle exec rake db:migrate
RAILS_ENV=production bundle exec rake assets:precompile
bundle exec puma -e production 1> log/console.log 2> log/console_err.log &