require "json"

module Split
  module Persistence
    class CookieAdapter

      EXPIRES = Time.now + 31536000 # One year from now

      def initialize(context, request=nil)
        @cookies = request.try(:cookies) || context.send(:cookies)
        @request = request
      end

      def [](key)
        hash[key]
      end

      def []=(key, value)
        set_cookie(hash.merge(key => value))
      end

      def delete(key)
        set_cookie(hash.tap { |h| h.delete(key) })
      end

      def keys
        hash.keys
      end

      private

      def set_cookie(value)
          @cookies[:split] = {
            :value => JSON.generate(value),
            :expires => EXPIRES
          }
        end
      end

      def hash
        if @cookies[:split]
          begin
            if @cookies[:split] && @cookies[:split].is_a?(Hash)
              JSON.parse(@cookies[:split][:value])
            else
              JSON.parse(@cookies[:split])
            end
          rescue JSON::ParserError
            {}
          end
        elsif @cookies["split"]
          begin
            if @cookies["split"] && @cookies["split"].is_a?(Hash)
              JSON.parse(@cookies["split"][:value])
            else
              JSON.parse(@cookies["split"])
            end
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
