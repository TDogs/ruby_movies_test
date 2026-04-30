module Admins
  class BaseController < ApplicationController
    skip_forgery_protection
    before_action :authenticate_admin_jwt!, unless: :jwt_public_action?

    private

    attr_reader :current_admin, :current_admin_payload, :current_admin_jwt, :current_admin_token

    def authenticate_admin_jwt!
      auth_header = request.headers["AccessToken"].to_s
      # 兼容部分前端把 token 放在 body/query 里（推荐还是走 header）
      auth_header = "bearer #{params[:accessToken]}" if auth_header.blank? && params[:accessToken].present?
      match = auth_header.match(/\Abearer\s+(.+)\z/)

      return render_unauthorized!("AccessToken 格式错误，应为: bearer <jwt>") unless match

      token = match[1].to_s
      payload = decode_token(token)
      return unless payload

      if JwtDenylist.revoked?(payload["jti"])
        return render_unauthorized!("JWT 已登出失效，请重新登录")
      end

      @current_admin_token = token
      @current_admin_jwt = payload
      @current_admin_payload = extract_sub_payload(payload["sub"])
      admin_id = @current_admin_payload["id"]
      @current_admin = ::Admin.find_by(id: admin_id)

      render_unauthorized!("管理员不存在") unless @current_admin
    end

    def decode_token(token)
      secret = ENV["JWT_SECRET"].presence || Rails.application.secret_key_base
      decoded = JWT.decode(token, secret, true, { algorithm: "HS256" })
      decoded.first
    rescue JWT::DecodeError, JWT::VerificationError, JWT::ExpiredSignature => e
      render_unauthorized!("JWT 无效: #{e.message}")
      nil
    end

    def extract_sub_payload(sub_payload)
      raw_payload = sub_payload.is_a?(Array) ? sub_payload.first : sub_payload
      raw_payload.is_a?(Hash) ? raw_payload.with_indifferent_access : {}
    end

    # 设置不走验证
    def jwt_public_action?
      controller_name == "admin" && action_name == "login"
    end

    def render_unauthorized!(message)
      render json: { error: message }, status: :unauthorized
    end

    # 兼容 Admin 端控制器使用的统一 JSON 渲染方法
    def render_json(data:, status: :ok)
      render json: data, status:
    end


    # 统一错误返回
    def render_error(message:, status: :bad_request, details: nil)
      payload = { error: message }
      payload[:details] = details if details.present?
      render json: payload, status:
    end
  end
end
