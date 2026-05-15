require "fileutils"

module Admins
  class MoviesController < BaseController
    # movie details
    def dtl
      movie = Movie.find(params[:id])
      render_json(data: movie)
    end

    # search movies list
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

    def update
      movie = Movie.find(params[:id])
      attrs = movie_update_params
      file = attrs["poster_url"].presence || attrs[:poster_url].presence
      if file.present?
        ActiveRecord::Base.transaction do
          movie.update!(attrs.except("poster_url", :poster_url))
          movie.assign_image_upload_then_persist!(file)
        end
      else
        unless movie.update(attrs.except("poster_url", :poster_url))
          return render json: { message: movie.errors }, status: :unprocessable_entity
        end
      end
      render json: {
        code: 200,
        msg: "success"
      }
    rescue ActiveRecord::RecordInvalid
      render json: { record_invalid_message: movie.errors }, status: :unprocessable_entity
    rescue StandardError => e
      render json: { other_message: e.message }, status: :unprocessable_entity
    end

    def del
      movie = Movie.find(params[:id])
      movie.update(is_deleted: 1)
      render json: {
        code: 200,
        msg: "success"
      }
    end

    def upload
      file = params[:file]
      if file.present?
        dir = Rails.root.join("public", "uploads")
        FileUtils.mkdir_p(dir)
        file_path = dir.join(file.original_filename)
        File.binwrite(file_path, file.read)

        Movie.find(params[:id]).update(poster_url: file.original_filename)

        render json: { msg: "文件上传成功", code: 200, data: { file_path: "xxxxxxxxxxxx" } }
      else
        render json: { msg: "文件上传失败", code: 200, data: {} }
      end
    end

    private

    def movie_update_params
      raw = params.permit(
        :rating, :release_date, :duration_minutes, :region, :poster_url, :drama,
        :image, # 单文件上传用标量 permit；image: [] 是给「数组参数」用的，容易拦掉 UploadedFile
        :director, # 可与 directors 二选一：单字符串/逗号分隔
        directors: [ :name ], # 对象
        categories: [] # 数组 可以传多个
      )

      attrs = raw.to_h
      directors = attrs["directors"].presence || attrs["director"]
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
