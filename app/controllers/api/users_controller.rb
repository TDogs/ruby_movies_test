module Api
  class UsersController < BaseController
    # 注册 弃用
    def reg
      encrypted_password = Utils.md5_hash(attrs[:password])
      u = User.new(params.permit(:username, password: encrypted_password))
      return render_error(message: u.errors.full_messages.to_sentence) unless u.save
      render_json(
        code: 200,
        msg: "注册成功",
        data: {
          user: u
        }
      )
    end

    # 登陆/注册 返回token
    def login
      return unless validate_login_params!

      attrs = filter_params

      encrypted_password = Utils.md5_hash(attrs[:password])

      # 查询是否有该用户
      hasUser = User.find_by(username: attrs[:username])
      expires_in = 2.hours.to_i

      # 存在 切用户名 密码正确
      if hasUser.present?
        if hasUser.password == encrypted_password
           token = Utils.build_user_jwt(hasUser, exp_seconds: expires_in)
          render json: {
            code: 200,
            msg: "登录成功",
            token_type: "bearer",
            accessToken: token,
            expires_in: expires_in
          }
        else
          render json: {
            code: 400,
            msg: "用户名或密码错误"
          }
        end
      else
        # 注册
        u = User.new(username: attrs[:username], password: encrypted_password)
        return render_error(message: u.errors.full_messages.to_sentence) unless u.save
        token = Utils.build_user_jwt(u, exp_seconds: expires_in)
        render json: {
          code: 200,
          msg: "注册成功",
          token_type: "bearer",
          accessToken: token,
          expires_in: expires_in
      }
      end
    end

    # 收藏 ==
    def collect
      render_json(data: { ok: true })
    end

    # 用户信息
    def info
      render_json(data: {
        code: 200,
        msg: "success",
        data: {
          user: current_user
        }
      })
    end

    # 更新
    def update
      render_json(data: { ok: true })
    end

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
        :username
      )
    end
  end
end
