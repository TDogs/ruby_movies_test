Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    # 临时：全开放所有
    origins "*"

    resource "/api/*",
      headers: :any,
      methods: %i[get post put patch delete options head],
      expose: [],
      max_age: 600

    # 放开  restful 路由 风格
    resource "/movies/*",
      headers: :any,
      methods: %i[get options head],
      expose: [],
      max_age: 600
  end
end

