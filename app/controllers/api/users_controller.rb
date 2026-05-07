module Api
  class UsersController < BaseController
    skip_before_action :verify_authenticity_token, only: %i[create login]

    # 注册
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

    # 登陆 返回token
    def login
      encrypted_password = Utils.md5_hash(attrs[:password])
      user = User.find_by(username: attrs[:username], password: encrypted_password)

      if user.present?
        expires_in = 2.hours.to_i
        token = Utils.build_admin_jwt(user, exp_seconds: expires_in)
        render json: {
          code: 200,
          msg: "登录成功",
          token_type: "bearer",
          accessToken: token,
          expires_in: expires_in
        }
      else
        render json: { message: "用户名或密码错误" }
      end
    end
  end
end
