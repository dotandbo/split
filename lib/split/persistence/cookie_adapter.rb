require "json"

module Split
  module Persistence
    class CookieAdapter

      EXPIRES = Time.now + 31536000 # One year from now

      def initialize(context, request=nil)
        binding.pry
        @cookies = request.try(:cookies) || context.send(:cookies)
        @request = request
      end

      def [](key)
        binding.pry
        hash[key]
      end

      def []=(key, value)
        binding.pry
        set_cookie(hash.merge(key => value))
      end

      def delete(key)
        binding.pry
        set_cookie(hash.tap { |h| h.delete(key) })
      end

      def keys
        binding.pry
        hash.keys
      end

      private

      def set_cookie(value)
        if @request
          binding.pry
          @cookies["split"][:value] = {
            :value => JSON.generate(value),
            :expires => EXPIRES
          } 
        else
          @cookies[:split] = {
            :value => JSON.generate(value),
            :expires => EXPIRES
          }
        end
      end

      def hash
        binding.pry
        if @cookies[:split]
          begin
            JSON.parse(@cookies[:split])
          rescue JSON::ParserError
            {}
          end
        elsif @cookies["split"]
          begin
            JSON.parse(@cookies["split"][:value])
          rescue JSON::ParserError
            {}
          end
        else
          {}
        end
      end

    end
  end
end
