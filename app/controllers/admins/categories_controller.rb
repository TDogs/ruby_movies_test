module Admins
  class CategoriesController < BaseController
    before_action :set_category, only: %i[ show update destroy ]

    # GET /categories
    # GET /categories.json
    def index
      @categories = Category.filter(params).includes(:goods, :attrs).order(created_at: :desc).all # 预加载 goods 和 attrs

      page = [ params.fetch(:page, 1).to_i, 1 ].max
      page_size = if params[:page_size].present?
        [ [ params[:page_size].to_i, 1 ].max, 20 ].min
      else
        10
      end

      total = @categories.count

      categories = @categories
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
          items: categories.as_json(
            include: {
              goods: { only: [ :id, :name ] },
              attrs: { only: [ :id, :name ] }
            }
          )
        }
      )
    end


    # 创建分类
    def create
      @category = Category.new(category_params)
      if @category.save
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
            msg: @category.errors
          }
        )
      end
    end

    # GET /admin/parent_category — 获取分类下拉，根据level获取
    def select_categories
      items = Category.filter(select_categories_params).pluck(:id, :name, :parent_id).map do |id, name, parent_id|
        { value: id, label: name, parent_id: parent_id }
      end
      render_json(
        data: {
          code: 200,
          msg: "success",
          items:
        }
      )
    end

    # 获取指定分类下已有的属性
    def selected_attributes_by_category_id
      @category = Category.find(params.expect(:category_id))
      render_json(
        data: {
          code: 200,
          msg: "success",
          items: @category.attrs.pluck(:id)
        }
      )
    end


    # 更新分类属性 中间表
    def update_category_attribute_by_id
      category_id = params.expect(:category_id,)
      attribute_ids = params.expect(attribute_ids: [])
      #  删除重建
      if category_id.present? && attribute_ids.present?
        begin
          ActiveRecord::Base.transaction do
            CategoriesAttribute.where(category_id: category_id).destroy_all
            category_attrs = attribute_ids.map do |attribute_id|
              { category_id: category_id, attribute_id: attribute_id }
            end
            CategoriesAttribute.insert_all(category_attrs)
          end
          render_json(
            data: {
              code: 200,
              msg: "保存成功"
            }
          )
        rescue StandardError => e
          render_json(
            data: {
              code: 300,
              msg: "保存失败: #{e.message}"
            }
          )
        end
      else
        render_json(
          data: {
            code: 400,
            msg: "参数错误"
          }
        )
      end
    end

    # PATCH/PUT /categories/1
    # PATCH/PUT /categories/1.json
    def update
      if @category.update(category_params)
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
            msg: @category.errors
          }
        )
      end
    end

    # DELETE /categories/1
    # DELETE /categories/1.json
    def destroy
      @category.destroy!
    end

    def  show
      render_json(
        data: {
          code: 200,
          msg: "success",
          item: @category.as_json(only: [ :id, :name ])
        }
      )
    end


    private
      # Use callbacks to share common setup or constraints between actions.
      def set_category
        @category = Category.find(params.expect(:id))
      end

       def select_categories_params
        params.permit(:level)
      end

      # Only allow a list of trusted parameters through.
      def category_params
        params.permit(:name, :parent_id)
      end
  end
end
