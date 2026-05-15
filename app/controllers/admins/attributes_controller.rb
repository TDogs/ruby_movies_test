module Admins
  class AttributesController < BaseController
    before_action :set_attribute, only: %i[ show update destroy ]

    # GET /attributes
    # GET /attributes.json
    def index
      # 预加载 categories，避免列表里访问分类名时 N+1
      @attributes = Attribute.filter(params).includes(:categories, :goods).order(created_at: :desc).all
      page = [ params.fetch(:page, 1).to_i, 1 ].max
      page_size = if params[:page_size].present?
        [ [ params[:page_size].to_i, 1 ].max, 20 ].min
      else
        10
      end

      total = @attributes.count

      attrs = @attributes.order(id: :desc)
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
          items:  attrs.as_json(include: { categories: { only: [ :name, :id ] }, goods: { only: [ :name, :id ] } })
        }
      )
    end

    # GET /attributes/1
    # GET /attributes/1.json
    def show
    end

    # POST /attributes
    # 创建属性
    def create
      @attribute = Attribute.new(attribute_params)

      if @attribute.save
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
            msg: @attribute.errors
          }
        )
      end
    end

    # PATCH/PUT /attributes/1
    # 更新属性
    def update
      if @attribute.update(attribute_params)
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
            msg: @attribute.errors
          }
        )
      end
    end

    # DELETE /attributes/1
    # DELETE /attributes/1.json
    def destroy
      @attribute.destroy!
    end

    # 获取带分页属性下拉
    def attribute_options
      attribute_options = Attribute.filter(params).order(created_at: :desc).all
      page = [ params.fetch(:page, 1).to_i, 1 ].max
      page_size = if params[:page_size].present?
        [ [ params[:page_size].to_i, 1 ].max, 20 ].min
      else
        10
      end

      total = attribute_options.count

      attribute_options = attribute_options.order(id: :desc)
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
          items:  attribute_options.as_json({ only: [ :id, :name ] })
        }
      )
    end
    private
      # Use callbacks to share common setup or constraints between actions.
      def set_attribute
        @attribute = Attribute.find(params.expect(:id))
      end

      def attribute_params
        params.permit(:name)
      end
  end
end
