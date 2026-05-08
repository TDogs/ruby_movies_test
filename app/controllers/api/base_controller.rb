module Api
  class BaseController < ApplicationController
    # close csrf verify
    skip_before_action :verify_authenticity_token

    # set only "collect", "info", "update" actions to authenticate_user_jwt!
    before_action :authenticate_user_jwt!, if: -> { action_name == "collect" || action_name == "info" || action_name == "update" }

    def render_json(data:, status: :ok)
      render json: data, status:
    end

    def render_error(message:, status: :bad_request, details: nil)
      payload = { error: message }
      payload[:details] = details if details.present?
      render json: payload, status:
    end

    private

    # add gloabl variable @current_user
    attr_reader :current_user

    def authenticate_user_jwt!
      h = request.headers["AccessToken"].to_s

      m = h.match(/\Abearer\s+(.+)\z/i)
      return render_unauthorized!("密钥 格式错误") unless m

      payload = JWT.decode(m[1], Utils.user_jwt_secret, true, { algorithm: "HS256" }).first

      return render_unauthorized!("密钥 已失效") if JwtDenylist.revoked?(payload["jti"])

      user_id = payload.dig("sub", 0, "id")
      return render_unauthorized!("无效密钥") unless user_id

      @current_user = UsersNew.find_by(id: user_id)
      render_unauthorized!("用户不存在") unless @current_user

    rescue JWT::DecodeError, JWT::VerificationError, JWT::ExpiredSignature => e
      render_unauthorized!("密钥 无效: #{e.message}")
    end

    def render_unauthorized!(message)
      render json: { error: message }, status: :unauthorized
    end
  end
end
