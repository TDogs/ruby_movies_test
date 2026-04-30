module Api
  class BaseController < ApplicationController
    # 统一 JSON 输出格式，避免每个控制器重复写 render json: ...
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

