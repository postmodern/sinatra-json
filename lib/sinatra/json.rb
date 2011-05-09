require 'sinatra/base'

module Sinatra
  ##
  # Adds a helper method for generation json:
  #
  #   require 'sinatra/json'
  #   get('/') { json :foo => 'bar' }
  #
  # Per default it's using its own, rather simple encoder.
  # You can easily change that:
  #
  #   # will automatically pick up JSON
  #   require 'json'
  #
  #   # will automatically pick up Yajl::Encoder
  #   require 'yajl'
  #
  #   # doesn't know Whatever, so you'll have to set it explicitely
  #   require 'whatever'
  #   set :json_encoder, Whatever
  #
  #   # Have #json simply call #to_json
  #   set :json_encoder, :to_json
  #
  #   # Or, you know, any method
  #   set :json_encoder, :my_fancy_json_method
  #
  # It will automatically set the content type to "application/json"
  # You can easily change that:
  #
  #   set :json_content_type, :js
  #
  # You can also pass those to the json method:
  #
  #   get('/') do
  #     json({:foo => 'bar'}, :encoder => :to_json, :content_type => :js)
  #   end
  module JSON
    class << self
      def encode(object)
        enc object, Array, Hash
      end

      private

      def enc(o, *a)
        o = o.to_s if o.is_a? Symbol
        fail "invalid: #{o.inspect}" unless a.empty? or a.include? o.class
        case o
        when Float  then o.nan? || o.infinite? ? 'null' : o.inspect
        when TrueClass, FalseClass, NilClass, Numeric, String then o.inspect
        when Array  then map(o, "[%s]") { |e| enc(e) }
        when Hash   then map(o, "{%s}") { |k,v| enc(k, String) + ":" + enc(v) }
        end
      end

      def map(o, wrapper, &block)
        wrapper % o.map(&block).join(',')
      end
    end

    def json(object, options = {})
      encoder = options[:encoder] || settings.json_encoder
      content_type options[:content_type] || settings.json_content_type
      if encoder.respond_to? :encode then encoder.encode(object)
      elsif encoder.respond_to? :generate then encoder.generate(object)
      elsif encoder.is_a? Symbol then object.__send__(encoder)
      else fail "#{encoder} does not respond to #generate nor #encode"
      end
    end
  end

  Base.set :json_encoder do
    return Yajl::Encoder if defined? Yajl::Encoder
    return JSON if defined? JSON
    return :to_json if {}.respond_to? :to_json and [].respond_to? :to_json
    Sinatra::JSON
  end

  Base.set :json_content_type, :json
  helpers JSON
end
