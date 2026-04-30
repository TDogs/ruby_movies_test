require "digest"
require "securerandom"

module Utils
  def self.md5_hash(value)
    Digest::MD5.hexdigest(value.to_s)
  end

  def self.jwt_secret
    ENV["JWT_SECRET"].presence || Rails.application.secret_key_base
  end

  def self.build_admin_jwt(admin, exp_seconds: 2.hours.to_i)
    now = Time.current.to_i
    payload = {
      iss: "admin/login",
      iat: now,
      nbf: now,
      exp: now + exp_seconds,
      jti: SecureRandom.hex(12),
      sub: [ "id" => admin.id, "username" => admin.username, "role" => admin.role, "status" => admin.status ]
    }

    JWT.encode(payload, jwt_secret, "HS256")
  end
end
