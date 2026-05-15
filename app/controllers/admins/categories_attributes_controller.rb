module Admins
  class CategoriesAttributesController < BaseController
    before_action :set_categories_attribute, only: %i[ show update destroy ]

    # GET /categories_attributes
    # GET /categories_attributes.json
    def index
      @categories_attributes = CategoriesAttribute.all
      page = [ params.fetch(:page, 1).to_i, 1 ].max
      page_size = if params[:page_size].present?
        [ [ params[:page_size].to_i, 1 ].max, 20 ].min
      else
        10
      end

      total = @categories_attributes.count
      categories_attributes = @categories_attributes.order(id: :desc)
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
        items: categories_attributes.as_json
      }
    end

    # GET /categories_attributes/1
    # GET /categories_attributes/1.json
    def show
    end

    # POST /categories_attributes
    # POST /categories_attributes.json
    def create
      @categories_attribute = CategoriesAttribute.new(categories_attribute_params)

      if @categories_attribute.save
        render json: { message: "创建成功" }
      else
        render json: { record_invalid_message: @categories_attribute.errors }
      end
    end

    # PATCH/PUT /categories_attributes/1
    # PATCH/PUT /categories_attributes/1.json
    def update
      if @categories_attribute.update(categories_attribute_params)
        render :show, status: :ok, location: @categories_attribute
      else
        render json: @categories_attribute.errors, status: :unprocessable_entity
      end
    end

    # DELETE /categories_attributes/1
    # DELETE /categories_attributes/1.json
    def destroy
      @categories_attribute.destroy!
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_categories_attribute
        @categories_attribute = CategoriesAttribute.find(params.expect(:id))
      end

      # Only allow a list of trusted parameters through.
      def categories_attribute_params
        params.permit(:category_id, :attribute_id)
      end
  end
end
