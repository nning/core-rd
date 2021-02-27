# core-rd

[![Dependency Status](https://img.shields.io/gemnasium/nning/core-rd.svg)](https://gemnasium.com/nning/core-rd)
[![Build Status](https://img.shields.io/travis/nning/core-rd.svg)](https://travis-ci.org/nning/core-rd)
[![Coverage Status](https://img.shields.io/coveralls/nning/core-rd.svg)](https://coveralls.io/r/nning/core-rd)
[![Code Climate](https://img.shields.io/codeclimate/github/nning/core-rd.svg)](https://codeclimate.com/github/nning/core-rd)

Rails application implementing a [CoRE Resource Directory](https://tools.ietf.org/html/draft-ietf-core-resource-directory-02).

## Startup

    rackup

## Quick start in Docker

    docker build . -t core-rd
    docker run -it core-rd

(IPv6 and multicast will probably not supported properly out-of-the-box but this
is a quick way to start the server without manual setup.)

## TODO

* `GET /` without `accept: 'application/json'` tries to find template in
  CoRE::Link format and fails with 5.00.

## Copyright

The code is published under the MIT license (see the LICENSE file).

### Authors

* [henning mueller](https://nning.io)
