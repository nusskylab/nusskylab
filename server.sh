#!/usr/bin/env bash
killall ruby
source ~/.bash_profile
rbenv shell 2.2.1
git checkout master
git pull
bundle install
rake db:migrate RAILS_ENV=production
puma -e production 1> log/console.log 2> log/console_err.log &
