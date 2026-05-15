module Admins
  class GoodsController < BaseController
    before_action :set_good, only: %i[ show update destroy ]

    # GET /goods
    # GET /goods.json
    def index
      @goods = Good.filter(params).includes(:category).order(created_at: :desc).all
      # @goods = Good.filter(params).order(created_at: :desc).all

      page = [ params.fetch(:page, 1).to_i, 1 ].max
      page_size = if params[:page_size].present?
        [ [ params[:page_size].to_i, 1 ].max, 20 ].min
      else
        10
      end

      total = @goods.count
      @goods = @goods.order(id: :desc)
        .offset((page - 1) * page_size)
        .limit(page_size)
      render json: {
        code: 200,
        msg: "success",
        pagination: {
          page:,
          page_size:,
          total:
        },
        items: @goods.as_json(include: { category: { only: [ :name, :id ] } })
      }
    end

    # GET /goods/1
    # GET /goods/1.json
    def show
    end

    # POST /goods
    # POST /goods.json
    def create
      @good = Good.new(good_params)

      if @good.save
        render_json(
          data: {
            code: 200,
            msg: "success"
          }
        )
      else
        render_json(
          data: {
            code: 400,
            msg: @good.errors
          }
        )
      end
    end

    # PATCH/PUT /goods/1
    # PATCH/PUT /goods/1.json
    def update
      if @good.update(good_params)
        render_json(
          data: {
            code: 200,
            msg: "success"
          }
        )
      else
        render_json(
          data: {
            code: 400,
            msg: @good.errors
          }
        )
      end
    end

    # DELETE /goods/1
    # DELETE /goods/1.json
    def destroy
      @good.destroy!
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_good
        @good = Good.find(params.expect(:id))
      end

      # Only allow a list of trusted parameters through.
      def good_params
        params.permit(:name, :category_id)
      end
  end
end
