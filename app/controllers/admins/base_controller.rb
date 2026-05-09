module Admins
  class BaseController < ApplicationController
    skip_forgery_protection
    before_action :authenticate_admin_jwt!, unless: :jwt_public_action?

    private

    attr_reader :current_admin, :current_admin_payload, :current_admin_jwt, :current_admin_token

    def authenticate_admin_jwt!
      auth_header = request.headers["AccessToken"].to_s
      match = auth_header.match(/\Abearer\s+(.+)\z/)

      return render_unauthorized!("Token 格式错误，应为: bearer <jwt>") unless match

      token = match[1].to_s
      payload = decode_token(token)
      return unless payload

      if JwtDenylist.revoked?(payload["jti"])
        return render_unauthorized!("Token 已登出失效，请重新登录")
      end

      @current_admin_token = token
      @current_admin_jwt = payload
      @current_admin_payload = extract_sub_payload(payload["sub"])
      @current_admin = ::Admin.find_by(id: @current_admin_payload["id"])
      render_unauthorized!("管理员不存在") unless @current_admin
    end

    def decode_token(token)
      decoded = JWT.decode(token, Utils.admin_jwt_secret, true, { algorithm: "HS256" })
      decoded.first
    rescue JWT::DecodeError, JWT::VerificationError, JWT::ExpiredSignature => e
      render_unauthorized!("JWT 无效: #{e.message}")
      nil
    end

    def extract_sub_payload(sub_payload)
      raw_payload = sub_payload.is_a?(Array) ? sub_payload.first : sub_payload
      raw_payload.is_a?(Hash) ? raw_payload.with_indifferent_access : {}
    end

    # set no check
    def jwt_public_action?
      controller_name == "admin" && action_name == "login" || action_name == "register"
    end

    def render_unauthorized!(message)
      render json: { error: message }, status: :unauthorized
    end

    def render_json(data:, status: :ok)
      render json: data, status:
    end


    def render_error(message:, status: :bad_request, details: nil)
      payload = { error: message }
      payload[:details] = details if details.present?
      render json: payload, status:
    end
  end
end
