module Admins
  class TestUploadsController < BaseController
    before_action :set_test_upload, only: %i[show update destroy show_multi update_multi destroy_multi]

    COLUMNS = %i[id title body created_at updated_at].freeze

    def index
      TestUpload.find_each(batch_size: 100) do |test_upload|
        p test_upload.image_url
      end
      render_json(data: TestUpload.order(id: :desc))
    end

    def show
      render_json(data: @test_upload)
    end

    def create
      p = test_upload_params
      file = p[:image]  # 获取图片文件信息
      p "==========create=========="
      p file
      p "==========create=========="
      if file.present?
        ActiveRecord::Base.transaction do
          @test_upload = TestUpload.new(p.except(:image))  # 过滤image 实例test_upload
          # 开启事务 防止第三方失败 db正常写入
          ActiveRecord::Base.transaction do
            @test_upload.save! # 保存数据库
            @test_upload.assign_image_upload_then_persist!(file) # 上传图片到OSS
          end
        end
      else
        @test_upload = TestUpload.new(p.except(:image))
      end
      render json: { message: "创建成功" }
      # 捕获异常
    rescue ActiveRecord::RecordInvalid
      render json: { record_invalid_message: @test_upload.errors }
    # 捕获其他异常
    rescue StandardError => e
      render json: { other_message: e.message }, status: :unprocessable_entity
    end

    def update
      p = test_upload_params
      file = p[:image]
      # 有的话 走事务处理同步上传oss 否则直接更新数据库
      if file.present?
        ActiveRecord::Base.transaction do
          @test_upload.update!(p.except(:image))
          @test_upload.assign_image_upload_then_persist!(file)
        end
      elsif !@test_upload.update(p.except(:image))
        return render json: { message: @test_upload.errors }
      end
      render json: { message: "更新成功" }
    rescue ActiveRecord::RecordInvalid
      render json: { record_invalid_message: @test_upload.errors }
    rescue StandardError => e
      render json: { other_message: e.message }, status: :unprocessable_entity
    end

    def destroy
      @test_upload.destroy!
      # head :no_content # 仅返回状态码
      render json: { message: "删除成功" } # 返回消息
    end

    def index_multi
      render_json(data: TestUpload.order(id: :desc))
    end


    # 测试多图上传
    def create_multi
      p = test_upload_images_params
      files = p[:images]
      if files.blank?
        return render json: { message: "图片不能为空" }, status: :unprocessable_entity
      end

      @test_upload = TestUpload.new(p.except(:images))

      ActiveRecord::Base.transaction do
        @test_upload.save!
        @test_upload.assign_images_upload_then_persist!(files)
      end
    render json: { message: "创建成功" }
    rescue ActiveRecord::RecordInvalid
      render json: { record_invalid_message: @test_upload.errors }
    rescue StandardError => e
      render json: { other_message: e.message }, status: :unprocessable_entity
    end

    def show_multi
      render_json(data: @test_upload)
    end

    # 测试多图更新
    def update_multi
      p = test_upload_images_params
      files = p[:images]

      p "==========update_multi=========="
      p files
      p "==========update_multi=========="
      if files.present?
        ActiveRecord::Base.transaction do
          @test_upload.update!(p.except(:images))
          @test_upload.assign_images_upload_then_persist!(files)
        end
      elsif !@test_upload.update(p.except(:images))
        return render json: { message: @test_upload.errors }
      end
      render json: { message: "更新成功" }
    rescue ActiveRecord::RecordInvalid
      render json: { message: @test_upload.errors }
    rescue StandardError => e
      render json: { message: e.message }, status: :unprocessable_entity
    end

    def destroy_multi
      @test_upload.destroy!
      render json: { message: "删除成功" }
    end

    private

    def set_test_upload
      @test_upload = TestUpload.find(params.expect(:id))
    end

    def test_upload_params
      params.expect(test_upload: %i[title body image])
    end

    def test_upload_images_params
      params.expect(test_upload: [ :title, :body, { images: [] } ])
    end
  end
end
