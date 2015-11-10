NUS Skylab
========================================================

[![Code Climate](https://codeclimate.com/github/nusskylab/nusskylab/badges/gpa.svg)](https://codeclimate.com/github/nusskylab/nusskylab) [![Test Coverage](https://codeclimate.com/github/nusskylab/nusskylab/badges/coverage.svg)](https://codeclimate.com/github/nusskylab/nusskylab/coverage) [![Build Status](https://travis-ci.org/nusskylab/nusskylab.svg?branch=iss77)](https://travis-ci.org/nusskylab/nusskylab) [![security](https://hakiri.io/github/nusskylab/nusskylab/master.svg)](https://hakiri.io/github/nusskylab/nusskylab/master)

### Introduction

NUS Skylab is the project for managing Orbital program in NUS. For more info about Orbital, see [Introduction to Orbital](https://github.com/nusskylab/nusskylab/blob/master/docs/orbital.md).


### Setup

Skylab uses PostgreSQL for data storage and uses capybara for acceptance testing. Therefore, you should make sure you have PostgreSQL installed and pre-requisites for development || test || production environments .

To install PostgreSQL, check its documentation [here](http://www.postgresql.org/download/). The recommended versions are 9.3 or 9.4. After PostgreSQL is installed, create a user with all priviledges of nusskylab, nussylab_dev, nuskylab_test databases. And change the user name and password in /config/database.yml to match with the user you just created.

And if you want to join the development and run tests, there are some additional setup for you to do. Gem capybara-webkit requires use of qt(>= 4.8) and xvfb, or “X virtual framebuffer”, for window simulation. The command below is for Ubuntu

```
sudo apt-get install xvfb
sudo apt-get install x11-xkb-utils
sudo apt-get install xfonts-100dpi xfonts-75dpi xfonts-scalable xfonts-cyrillic
```

Use bundler to install all dependencies and then run db:migration with rake task runner.

### Development

We are following the [GitHub Flow](https://guides.github.com/introduction/flow/index.html). See the [contributing guide](./docs/contributing_guide.md) for more details.


### Test

Run the tests with command:

```
bundle exec rake db:test:prepare
bundle exec rspec spec
```

### License

NUS Skylab is released under [MIT License](./LICENSE)
