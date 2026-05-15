# frozen_string_literal: true

require "connection_pool"

class JwtDenylist
  class << self
    def revoked?(jti)
      return false if jti.blank?
      with_client { |c| c.call("EXISTS", key_for(jti)) == 1 }
    end

    def revoke!(jti, exp:)
      return false if jti.blank?

      ttl = exp.to_i - Time.current.to_i
      return true if ttl <= 0

      with_client { |c| c.call("SET", key_for(jti), "1", "EX", ttl) }
      true
    end

    private

    def key_for(jti)
      "jwt:denylist:jti:#{jti}"
    end

    def with_client
      redis_pool.with { |client| yield(client) }
    end

    def redis_pool
      @redis_pool ||= ConnectionPool.new(size: pool_size, timeout: 5) do
        RedisClient.config(url: redis_url).new_client
      end
    end

    def pool_size
      raw = ENV.fetch("JWT_DENYLIST_REDIS_POOL_SIZE", ENV.fetch("RAILS_MAX_THREADS", "5"))
      Integer(raw).clamp(2, 50)
    rescue ArgumentError, TypeError
      5
    end

    def redis_url
      ENV.fetch("REDIS_URL", "redis://localhost:6379/0")
    end
  end
end
