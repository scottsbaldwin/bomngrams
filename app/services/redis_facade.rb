# frozen_string_literal: true

require 'uri'
require 'redis'
require 'singleton'

# Interface to the Redis client
class RedisFacade
  include Singleton

  def initialize
    @uri = URI.parse(ENV.fetch('REDIS_URL', 'redis://localhost:6379'))
  end

  def redis
    @redis ||= Redis.new(host: @uri.host, port: @uri.port, password: @uri.password)
  end
end
