require "fileutils"

module Admins
  class MoviesController < BaseController
    # 详情接口（json）
    def dtl
      movie = Movie.find(params[:id])
      render_json(data: movie)
    end

    # 查询接口
    def list
      page = [ params.fetch(:page, 1).to_i, 1 ].max
      page_size = params.fetch(:page_size, 10).to_i
      page_size = [ [ page_size, 1 ].max, 200 ].min

      base_scope = Movie.filter(filter_params)
      total = base_scope.count

      movies = base_scope
        .offset((page - 1) * page_size)
        .limit(page_size)

      render_json(
        data: {
          code: 200,
          msg: "success",
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

    # 路由目前走 movies#updat（历史原因）。这里提供 update 作为别名，方便直觉使用。
    def update = updat

    def updat
      movie = Movie.find(params[:id])
      attrs = movie_update_params
      r = movie.update(attrs)

      render json: {
        code: r ? 200 : 422,
        msg: r ? "success" : "failed",
        data: {
          attrs: attrs,
          previous_changes: movie.previous_changes,
          errors: movie.errors.full_messages,
          movie: movie
        }
      }
    end

    def upload
      file = params[:file]
      puts " ================== file: #{file} ================== "
      puts " ================== file---id: #{params[:id]} ================== "

      if file.present?
        dir = Rails.root.join("public", "uploads")
        FileUtils.mkdir_p(dir)
        file_path = dir.join(file.original_filename)
        File.binwrite(file_path, file.read)

        # Movie.find(params[:id]).update(poster_url: file.original_filename)

        render json: { msg: "文件上传成功", code: 200, data: { file_path: file_path.to_s } }
      else
        render json: { msg: "文件上传失败", code: 200, data: {} }
      end
    end

    private

    def movie_update_params
      params.permit(
        :rating, :release_date, :duration_minutes, :region, :poster_url, :drama,
        directors: [ :name ], # 对象 数组里每个元素是一个 Hash，只允许其中的 name 字段，例如 "directors": [{"name": "克里斯托夫·巴拉蒂"}] 接收不成功原因
        categories: [] # 数组 可以传多个
      )

      puts " ================== raw: #{raw} ================== "
      puts " ================== raw: #{raw.inspect} ================== "
      attrs = raw.to_h

      # 兼容前端传 director（字符串）场景：落库字段是 directors(jsonb)
      director = attrs.delete("director").presence
      directors = attrs["directors"].presence || director
      if directors.present?
        if directors.is_a?(Array) && directors.all? { |d| d.is_a?(Hash) && d["name"].present? }
          attrs["directors"] = directors
            .map { |d| { "name" => d["name"].to_s.strip } }
            .reject { |d| d["name"].blank? }
            .uniq
        else
          names = directors.is_a?(Array) ? directors : directors.to_s.split(",")
          names = names.map(&:to_s).map(&:strip).reject(&:blank?).uniq
          attrs["directors"] = names.map { |name| { "name" => name } }
        end
      end

      categories = attrs["categories"]
      if categories.present?
        arr = categories.is_a?(Array) ? categories : categories.to_s.split(",")
        attrs["categories"] = arr.map(&:to_s).map(&:strip).reject(&:blank?).uniq
      end

      attrs
    end

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
