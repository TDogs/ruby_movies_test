require "digest"
require "openssl"
require "securerandom"

module Utils
  def self.admin_jwt_secret
    ENV["JWT_SECRET_KEY"].presence || Rails.application.secret_key_base
  end

  # env key if exists,use env key. or use rails key and concat ":user_jwt"
  def self.user_jwt_secret
    ENV["USER_JWT_SECRET"].presence || "#{Rails.application.secret_key_base}:user_jwt"
  end

  def self.build_admin_jwt(admin, exp_seconds: 2.hours.to_i)
    now = Time.current.to_i
    payload = {
      iss: "admin/login",
      iat: now,
      nbf: now,
      exp: now + exp_seconds,
      jti: SecureRandom.hex(12),
      sub: [ "id" => admin.id, "username" => admin.username, "role" => admin.role ? admin.role : 0, "status" => admin.status ? admin.status : 0 ]
    }

    JWT.encode(payload, admin_jwt_secret, "HS256")
  end

  def self.build_user_jwt(user, exp_seconds = 2.hours.to_i)
    now = Time.current.to_i
    payload = {
      iss: "user/login",
      iat: now,
      nbf: now,
      exp: now + exp_seconds,
      jti: SecureRandom.hex(12),
      sub: [ "id" => user.id, "username" => user.username ]
    }
    JWT.encode(
      payload,
      user_jwt_secret,
      "HS256"
    )
  end
end
