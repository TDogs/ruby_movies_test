module Api
  class MoviesController < BaseController
    # 详情接口
    def dtl
      movie = Movie.find(params[:id])
      render_json(data: movie)
    end

    # 查询接口
    def index
      page = [params.fetch(:page, 1).to_i, 1].max
      page_size = params.fetch(:page_size, 10).to_i
      page_size = [[page_size, 1].max, 200].min

      base_scope = Movie.filter(filter_params)
      total = base_scope.count

      movies = base_scope
        .offset((page - 1) * page_size)
        .limit(page_size)

      render_json(
        data: {
          pagination: {
            page:,
            page_size:,
            total:
          },
          items: movies.as_json(
            only: [
              :id, :source_id, :source_url, :title, :categories, :region, :duration_minutes,
              :release_date, :poster_url, :drama, :directors, :actors, :rating, :created_at, :updated_at
            ]
          )
        }
      )
    end

    private

    def filter_params
      params.permit(
        :title,
        :category,
        :categories,
        :region,
        :duration_minutes_from,
        :duration_minutes_to,
        :release_date_from,
        :release_date_to,
        :poster_url,
        :drama,
        :director,
        :directors,
        :actor,
        :actors,
        :rating,
        :rating_min,
        :rating_max,
        :page,
        :page_size
      )
    end
  end
end
