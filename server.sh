#!/usr/bin/env bash
killall ruby
source ~/.bash_profile
git checkout master
git pull
bundle install
rake db:migrate RAILS_ENV=production
puma -e production -p 3000 1> log/console.log 2> log/console_err.log &
