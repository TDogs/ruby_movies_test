module Admins
  class BaseController < ApplicationController
    # set status constants
    RESPONSE_HTTP_STATUSES = {
      ok: 200,
      err: 300,
      bad_request: 400,
      unauthorized: 401,
      forbidden: 403,
      not_found: 404,
      conflict: 409,
      unprocessable_entity: 422,
      internal_server_error: 500
    }.freeze

    skip_forgery_protection #  close csrf verify
    rescue_from ActiveRecord::RecordNotFound, with: :render_record_not_found  # 拦截器 拦截所有与find这种严格查询 并抛notfund错误的
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
      %w[admin#login admin#register test_uploads#create test_uploads#destroy test_uploads#show test_uploads#update test_uploads#index_multi test_uploads#create_multi test_uploads#show_multi test_uploads#update_multi].include?("#{controller_name}##{action_name}")
    end

    # 统一返回 删除后 再次查询记录不存在 报错。或改写查询方法
    def render_record_not_found(_exception)
      render_json(data: { code: RESPONSE_HTTP_STATUSES[:err], msg: "记录不存在或已删除", data: nil })
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
      http_status = RESPONSE_HTTP_STATUSES.fetch(status, status)
      render json: payload, status: http_status
    end
  end
end
