module CFB
  class Error < StandardError; end
  class NotFound < Error; end
  class BadRequest < Error; end
  class TooManyRequests < Error; end
  class InternalServerError < Error; end
  class BadGateway < Error; end
  class ServiceUnavailable < Error; end
  class GatewayTimeout < Error; end
end