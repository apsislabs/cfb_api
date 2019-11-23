# frozen_string_literal: true

require 'faraday'

module CFB
  class ErrorMiddleware < Faraday::Middleware
    def call(env)
      @app.call(env).on_complete do |response|
        case response[:status].to_i
        when 400
          raise CFB::BadRequest, error_message_400(response)
        when 404
          raise CFB::NotFound, error_message_400(response)
        when 429
          raise CFB::TooManyRequests, error_message_400(response)
        when 500
          raise CFB::InternalServerError, error_message_500(response, 'Something is technically wrong.')
        when 502
          raise CFB::BadGateway, error_message_500(response, 'The server returned an invalid or incomplete response.')
        when 503
          raise CFB::ServiceUnavailable, error_message_500(response, 'Your requests are rate limited.')
        when 504
          raise CFB::GatewayTimeout, error_message_500(response, '504 Gateway Time-out')
        end
      end
    end

    def initialize(app)
      super app
      @parser = nil
    end

    private

    def error_message_400(response)
      "#{response[:method].to_s.upcase} #{response[:url]}: #{response[:status]}#{error_body(response[:body])}"
    end

    def error_body(body)
      # body gets passed as a string, not sure if it is passed as something else from other spots?
      if !body.nil? && !body.empty? && body.is_a?(String)
        # removed multi_json thanks to wesnolte's commit
        body = ::JSON.parse(body)
      end

      if body.nil?
        nil
      elsif body['meta'] && body['meta']['error_message'] && !body['meta']['error_message'].empty?
        ": #{body['meta']['error_message']}"
      elsif body['error_message'] && !body['error_message'].empty?
        ": #{body['error_type']}: #{body['error_message']}"
      end
    end

    def error_message_500(response, body = nil)
      "#{response[:method].to_s.upcase} #{response[:url]}: #{[response[:status].to_s + ':', body].compact.join(' ')}"
    end
  end
end
