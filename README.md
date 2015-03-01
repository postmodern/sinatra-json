# sinatra-json

* [Homepage](https://github.com/postmodern/sinatra-json#readme)
* [Issues](https://github.com/postmodern/sinatra-json/issues)
* [Documentation](http://rubydoc.info/gems/sinatra-json/frames)
* [Email](mailto:postmodern.mod3 at gmail.com)

[![Build Status](https://secure.travis-ci.org/postmodern/sinatra-json.svg)](https://travis-ci.org/postmodern/sinatra-json)

## Description

{Sinatra::JSON}, extracted from [sinatra-contrib].

## Features

* Encodes JSON responses.
* Sets Content-Type to `application/json`.
* Supports multiple JSON backends via [multi_json].

## Examples

    require 'sinatra/json'

    class App < Sinatra::Base

      get '/' do
        json(foo: 'bar')
      end

    end

## Requirements

* [multi_json] ~> 1.0
* [sinatra] ~> 1.0

## Install

    $ gem install sinatra-json

## Copyright

Copyright (c) 2009-2015 Konstantin Haase, Hal Brodigan

See {file:LICENSE.txt} for details.

[multi_json]: https://github.com/intridea/multi_json
[sinatra]: http://www.sinatrarb.com/
[sinatra-contrib]: https://github.com/sinatra/sinatra-contrib#readme
