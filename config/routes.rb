Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

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
end