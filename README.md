NUS Skylab
========================================================

[![Code Climate](https://codeclimate.com/github/nusskylab/nusskylab/badges/gpa.svg)](https://codeclimate.com/github/nusskylab/nusskylab) [![Test Coverage](https://codeclimate.com/github/nusskylab/nusskylab/badges/coverage.svg)](https://codeclimate.com/github/nusskylab/nusskylab/coverage) [![Build Status](https://travis-ci.org/nusskylab/nusskylab.svg?branch=iss77)](https://travis-ci.org/nusskylab/nusskylab)

### Introduction

NUS Skylab is the project for managing Orbital programme in NUS. For more info about Orbital, see [Introduction to Orbital](https://github.com/nusskylab/nusskylab/blob/master/docs/orbital.md).


### Setup

Use bundler to install all dependencies and then run db:migration with rake task runner.

### Development

We are following the [GitHub Flow](https://guides.github.com/introduction/flow/index.html). See the [contributing guide](https://github.com/nusskylab/nusskylab/blob/master/docs/contributing_guide.md) for more details.


### Test

Run the tests with command:

```
bundle exec rspec spec/
bundle exec rake test
```

*Before you run tests, make sure database migration is already done for test environment.*

### License

NUS Skylab is released under [MIT License](https://github.com/nusskylab/nusskylab/blob/master/LICENSE)
