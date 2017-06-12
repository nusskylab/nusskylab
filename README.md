NUS Skylab
========================================================

[![Code Climate](https://codeclimate.com/github/nusskylab/nusskylab/badges/gpa.svg)](https://codeclimate.com/github/nusskylab/nusskylab) [![Test Coverage](https://codeclimate.com/github/nusskylab/nusskylab/badges/coverage.svg)](https://codeclimate.com/github/nusskylab/nusskylab/coverage) [![Build Status](https://travis-ci.org/nusskylab/nusskylab.svg?branch=iss77)](https://travis-ci.org/nusskylab/nusskylab) [![security](https://hakiri.io/github/nusskylab/nusskylab/master.svg)](https://hakiri.io/github/nusskylab/nusskylab/master)

### Introduction

NUS Skylab is the project for managing Orbital program in NUS. For more info about Orbital, see [Introduction to Orbital](https://github.com/nusskylab/nusskylab/blob/master/docs/orbital.md).

### Setup

The recommended development environment setup is via Vagrant. Simply run `vagrant up` and you should get the server running in your localhost:3000--so make sure it could be bound by Vagrant though. [Vagrant setup instructions](https://github.com/nusskylab/nusskylab/wiki/Developing-NUSSkylab-with-Vagrant)

If you do not want to use Vagrant but instead you want to have a real local setup, see [bootstrap.sh](./bootstrap.sh) for steps needed for CentOS 7. For other OSes like Mac, Ubuntu, just translate those instructions for your own platform.

[Instructions for local setup for Mac OS] (https://github.com/nusskylab/nusskylab/wiki/Local-Installations-(Non-Vagrant))

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
