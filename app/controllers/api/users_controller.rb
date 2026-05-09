module Api
  class UsersController < BaseController
    # register, out
    def reg
      # encrypted_password = Utils.md5_hash(attrs[:password])
      # u = User.new(params.permit(:username, password: encrypted_password))
      # return render_error(message: u.errors.full_messages.to_sentence) unless u.save
      # render_json(
      #   code: 200,
      #   msg: "注册成功",
      #   data: {
      #     user: u
      #   }
      # )
    end

    # login or register and return token
    def login
      return unless validate_login_params!

      attrs = filter_params

      # check if user exists
      hasUser = User.find_by(username: attrs[:username])
      expires_in = 2.hours.to_i
      if hasUser.present?
        if hasUser&.authenticate(params[:password])
          token = Utils.build_user_jwt(hasUser,  expires_in)
          render json: {
            code: 200,
            msg: "登录成功",
            token_type: "bearer",
            accessToken: token,
            expires_in: expires_in
          } else
          render json: {
            code: 400,
            msg: "用户名或密码错误"
          }
        end
      else
        # register
        u = User.new(attrs)
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

    # user collect movie
    def collect
      render_json(data: { ok: true })
    end

    # user info
    def info
      logger.info("用户信息: #{current_user.inspect}")

      render_json(data: {
        code: 200,
        msg: "success",
        data: {
          user: current_user
        }
      })
    end

    # update user info
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
