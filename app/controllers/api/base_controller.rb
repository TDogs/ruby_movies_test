module Api
  class BaseController < ApplicationController
    # 仅限收藏需要验证
    skip_before_action :verify_authenticity_token, only: [ :collect ]
    before_action :authenticate_user_jwt!, only: [ :collect ]

    def render_json(data:, status: :ok)
      render json: data, status:
    end

    def render_error(message:, status: :bad_request, details: nil)
      payload = { error: message }
      payload[:details] = details if details.present?
      render json: payload, status:
    end

    private

    attr_reader :current_user, :current_user_jwt

    def authenticate_user_jwt!
      h = request.headers["AccessToken"].to_s
      h = "bearer #{params[:accessToken]}" if h.blank? && params[:accessToken].present?
      m = h.match(/\Abearer\s+(.+)\z/i)
      return render_unauthorized!("AccessToken 格式错误") unless m

      payload = JWT.decode(m[1], Utils.user_jwt_secret, true, { algorithm: "HS256" }).first
      return render_unauthorized!("JWT 已失效") if JwtDenylist.revoked?(payload["jti"])

      @current_user_jwt = payload
      @current_user = User.find_by(id: payload["sub"])
      render_unauthorized!("用户不存在") unless @current_user
    rescue JWT::DecodeError, JWT::VerificationError, JWT::ExpiredSignature => e
      render_unauthorized!("JWT 无效: #{e.message}")
    end

    def render_unauthorized!(message)
      render json: { error: message }, status: :unauthorized
    end
  end
end
