require 'sinatra/base'
require 'multi_json'

module Sinatra
  #
  # {Sinatra::JSON} adds a helper method, called {JSON#json json}, for
  # (obviously) json generation.
  #
  # ## Usage
  #
  # ### Classic Application
  #
  # In a classic application simply require the helper, and start using it:
  #
  #     require "sinatra"
  #     require "sinatra/json"
  #
  #     # define a route that uses the helper
  #     get '/' do
  #       json :foo => 'bar'
  #     end
  #
  #     # The rest of your classic application code goes here...
  #
  # ### Modular Application
  #
  # In a modular application you need to require the helper, and then tell the
  # application you will use it:
  #
  #     require "sinatra/base"
  #     require "sinatra/json"
  #
  #     class MyApp < Sinatra::Base
  #
  #       # define a route that uses the helper
  #       get '/' do
  #         json :foo => 'bar'
  #       end
  #
  #       # The rest of your modular application code goes here...
  #     end
  #
  # ### Encoders
  #
  # By default it will try to call `to_json` on the object, but if it doesn't
  # respond to that message, it will use its own rather simple encoder.  You can
  # easily change that anyways. To use `JSON`, simply require it:
  #
  #     require 'json'
  #
  # The same goes for `Yajl::Encoder`:
  #
  #     require 'yajl'
  #
  # For other encoders, besides requiring them, you need to define the
  # `:json_encoder` setting.  For instance, for the `Whatever` encoder:
  #
  #     require 'whatever'
  #     set :json_encoder, Whatever
  #
  # To force `json` to simply call `to_json` on the object:
  #
  #     set :json_encoder, :to_json
  #
  # Actually, it can call any method:
  #
  #     set :json_encoder, :my_fancy_json_method
  #
  # ### Content-Type
  #
  # It will automatically set the content type to "application/json".  As
  # usual, you can easily change that, with the `:json_content_type`
  # setting:
  #
  #     set :json_content_type, :js
  #
  # ### Overriding the Encoder and the Content-Type
  #
  # The `json` helper will also take two options `:encoder` and
  # `:content_type`.  The values of this options are the same as the
  # `:json_encoder` and `:json_content_type` settings,
  # respectively.  You can also pass those to the json method:
  #
  #     get '/'  do
  #       json({:foo => 'bar'}, :encoder => :to_json, :content_type => :js)
  #     end
  #
  module JSON
    class << self
      def encode(object)
        ::MultiJson.dump(object)
      end
    end

    def json(object, options = {})
      content_type resolve_content_type(options)
      resolve_encoder_action  object, resolve_encoder(options)
    end

    private

    def resolve_content_type(options = {})
      options[:content_type] || settings.json_content_type
    end

    def resolve_encoder(options = {})
      options[:json_encoder] || settings.json_encoder
    end

    def resolve_encoder_action(object, encoder)
      [:encode, :generate].each do |method|
        return encoder.send(method, object) if encoder.respond_to? method
      end
      if encoder.is_a? Symbol
        object.__send__(encoder)
      else 
        fail "#{encoder} does not respond to #generate nor #encode"
      end #if
    end #resolve_encoder_action  
  end #JSON

  Base.set :json_encoder do
    ::MultiJson
  end

  Base.set :json_content_type, :json

  # Load the JSON helpers in modular style automatically
  Base.helpers JSON
end
