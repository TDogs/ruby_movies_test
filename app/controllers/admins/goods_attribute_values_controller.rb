module Admins
  class GoodsAttributeValuesController < BaseController
    before_action :set_goods_attribute_value, only: %i[ show update destroy ]

    # GET /goods_attribute_values
    # GET /goods_attribute_values.json
    def index
      @goods_attribute_values = GoodsAttributeValue.all
      page = [ params.fetch(:page, 1).to_i, 1 ].max
      page_size = if params[:page_size].present?
        [ [ params[:page_size].to_i, 1 ].max, 20 ].min
      else
        10
      end

      total = @goods_attribute_values.count
      goods_attribute_values = @goods_attribute_values
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
        items: total > 0 ? goods_attribute_values.as_json : []
      }
    end

    # GET /goods_attribute_values/1
    # GET /goods_attribute_values/1.json
    def show
    end

    # POST /goods_attribute_values
    # POST /goods_attribute_values.json
    def create
      @goods_attribute_value = GoodsAttributeValue.new(goods_attribute_value_params)

      if @goods_attribute_value.save
        render json: { message: "创建成功" }
      else
        render json: { record_invalid_message: @goods_attribute_value.errors }
      end
    end

    # PATCH/PUT /goods_attribute_values/1
    # PATCH/PUT /goods_attribute_values/1.json
    def update
      if @goods_attribute_value.update(goods_attribute_value_params)
        render json: { message: "更新成功" }
      else
        render json: { record_invalid_message: @goods_attribute_value.errors }
      end
    end

    # DELETE /goods_attribute_values/1
    # DELETE /goods_attribute_values/1.json
    def destroy
      @goods_attribute_value.destroy!
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_goods_attribute_value
        @goods_attribute_value = GoodsAttributeValue.find(params.expect(:id))
      end

      # Only allow a list of trusted parameters through.
      def goods_attribute_value_params
        params.permit(:goods_id, :attribute_id, :value)
      end
  end
end
