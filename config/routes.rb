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
    post "users/reg", to: "users#reg"
    post "users/login", to: "users#login"

    # POST 开启爬虫任务 具体x-x页码
    post "scrape/movies", to: "scrapes#movies"

    # GET 列表
    get "movies", to: "movies#index"


    # GET  详情
    get "movies/:id", to: "movies#dtl"

    # 导出
    post "movies/export", to: "movies#export"

    # 收藏
    post "users/collect", to: "users#collect"

    # 用户信息
    get "users", to: "users#info"

    # 更新
    put "users", to: "users#update"
  end


  scope :admin, module: :admins do
    post "login", to: "admin#login"
    post "register", to: "admin#register"
      get "profile", to: "protected#profile"
      get "info", to: "admin#info"
      get "movies", to: "movies#list"
      post "logout", to: "admin#logout"
      post "movies/update/:id", to: "movies#update"
      post "movies/del/:id", to: "movies#del"
      post "upload", to: "movies#upload"

      # 资源 测试 本地 阿里oss 单图（create/update）/ 多图（*_multi）
      resources :test_uploads, only: %i[index show create update destroy] do
        collection do
          get  :multi, action: :index_multi   # GET  /admin/test_uploads/multi
          post :multi, action: :create_multi # POST /admin/test_uploads/multi  body: title, body, images[] (flat, no test_upload wrapper)
        end

        member do
          get   :multi, action: :show_multi    # GET   /admin/test_uploads/:id/multi
          patch :multi, action: :update_multi # PATCH /admin/test_uploads/:id/multi
        end
      end


    # 不严谨 手动测试 参数按规定看好来
    resources :goods
    resources :attributes
    get "attribute_options", to: "attributes#attribute_options"
    get "select_categories", to: "categories#select_categories" # get parent id = 0
    get "selected_attributes_by_category_id/:category_id", to: "categories#selected_attributes_by_category_id"
    put "update_category_attribute_by_id/:category_id", to: "categories#update_category_attribute_by_id"
    resources :categories
    resources :goods_attribute_values
    resources :categories_attributes
  end
end
