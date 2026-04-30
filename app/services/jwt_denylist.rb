class JwtDenylist
  class << self
    def revoked?(jti)
      return false if jti.blank?
      redis.call("EXISTS", key_for(jti)) == 1
    end

    def revoke!(jti, exp:)
      return false if jti.blank?

      ttl = exp.to_i - Time.current.to_i
      return true if ttl <= 0

      redis.call("SET", key_for(jti), "1", "EX", ttl)
      true
    end

    private

    def key_for(jti)
      "jwt:denylist:jti:#{jti}"
    end

    def redis
      @redis ||= RedisClient.config(url: redis_url).new_client
    end

    def redis_url
      ENV.fetch("REDIS_URL", "redis://localhost:6379/0")
    end
  end
end

