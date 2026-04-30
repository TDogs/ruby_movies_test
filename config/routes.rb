Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  # 队列仪表盘（Mission Control Jobs 仅支持 Solid Queue）
  if defined?(MissionControl::Jobs::Engine) &&
       ActiveJob::Base.queue_adapter.class.name.include?("SolidQueue")
    mount MissionControl::Jobs::Engine, at: "/jobs"
  else
    get "/jobs", to: proc { |_env|
      [
        404,
        { "Content-Type" => "text/plain; charset=utf-8" },
        [ "Mission Control Jobs 仅支持 Solid Queue。当前 adapter: #{ActiveJob::Base.queue_adapter.class.name}\n" ]
      ]
    }
  end

  # 首页（不带 /api 前缀，但走 Api::MoviesController#home）
  get "/home", to: "api/movies#home"
  # 详情页（非json）
  get "/dtl/:id", to: "api/movies#dtl_page"

  namespace :api do
    # POST 开启爬虫任务 具体x-x页码
    post "scrape/movies", to: "scrapes#movies"

    # GET 列表
    get "movies", to: "movies#index"


    # GET  详情
    get "movies/:id", to: "movies#dtl"

    # 导出
    post "movies/export", to: "movies#export"
  end


  scope :admin, module: :admins do
    post "login", to: "admin#login"

    scope :auth do
      get "profile", to: "protected#profile"
      get "info", to: "admin#info"
      get "movies", to: "movies#list"
      post "logout", to: "admin#logout"
      post "movies/update/:id", to: "movies#updat"
      post "upload", to: "movies#upload"
    end
  end
end
