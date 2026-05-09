module Admins
  class AdminController < BaseController
    def register
      return unless validate_login_params!
      attrs = filter_params
      admin = Admin.new(attrs)
      return render json: { message: admin.errors.full_messages.to_sentence } unless admin.save
      render json: { message: "注册成功" }
    end

    def login
      return unless validate_login_params!

      attrs = filter_params
      admin = Admin.find_by(username: attrs[:username])

      if admin.blank?
        return render json: { message: "用户不存在" }
      end

      if admin.authenticate(params[:password])
        expires_in = 2.hours.to_i
        token = Utils.build_admin_jwt(admin, exp_seconds: expires_in)
        render json: {
          code: 200,
          msg: "登录成功",
          token_type: "bearer",
          accessToken: token,
          expires_in: expires_in
        }
      else
        render json: { message: "登录失败" }
      end
    end

    def info
      # current_admin = admin实例
      data = current_admin.getInfoAndMenus(current_admin_payload)
      render json: {
        code: 200,
        msg: "success",
        data: data
      }
    end

    def logout
      # token 失效
      if current_admin_jwt.present?
        JwtDenylist.revoke!(current_admin_jwt["jti"], exp: current_admin_jwt["exp"])
      end

      render json: {
        code: 200,
        msg: "success"
      }
    end

    private

    def validate_login_params!
      attrs = filter_params
      errors = []

      errors << "username 为必填项" if attrs[:username].blank?
      errors << "password 为必填项" if attrs[:password].blank?

      if attrs[:username].present? && !attrs[:username].is_a?(String)
        errors << "username 类型错误，应为字符串"
      end
      if attrs[:password].present? && !attrs[:password].is_a?(String)
        errors << "password 类型错误，应为字符串"
      end

      return true if errors.empty?

      render json: { message: "参数校验失败", errors: errors }, status: :unprocessable_entity
      false
    end

    def filter_params
      params.permit(
        :password,
        :username,
        :phone
      )
    end
  end
end
