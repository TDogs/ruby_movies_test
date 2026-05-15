class TestUpload < ApplicationRecord
  # service: :aliyun  不能这么配置，api可正常，console会报错 “Cannot configure service”
  has_one_attached :image
  has_many_attached :images

  # 真正的 OSS 请求，是在has_one_attached底层的 after_commit 时异步触发的 ，不在事务中 导致图片上传失败 或者 三方存储配置参数有问题 导致最终上传失败时，数据库中被写入数据 但是oss没有数据。故需手动执行上传
  # 单图
  def assign_image_upload_then_persist!(uploaded_file)
    return if uploaded_file.blank?  # 检查

    image.detach if image.attached? # 删除原来挂在内存中的图片

    p " ================== 上传文件: #{uploaded_file} ================== "
    p " ================== 上传文件原始文件名: #{uploaded_file.original_filename} ================== "
    p " ================== 上传文件内容类型: #{uploaded_file.content_type} ================== "
    p " ================== 上传文件服务名称: #{:aliyun} ================== "
    # 强制同步上传：跳过 after_commit，手动 upload
    blob = ActiveStorage::Blob.create_and_upload!(
      io: uploaded_file,
      filename: uploaded_file.original_filename,
      content_type: uploaded_file.content_type,
      # service_name: :aliyun # 自己去找
    )

    image.attach(blob) # 将blob 关联到 模型，触发 写表 active_storage_attachments 和 active_storage_blobs
  end


  # 多图
  def assign_images_upload_then_persist!(uploaded_files)
    files = Array.wrap(uploaded_files).compact
    return if files.blank?

    images.detach if images.attached?

    blobs = files.map do |file|
      ActiveStorage::Blob.create_and_upload!(
        io: file,
        filename: file.original_filename,
        content_type: file.content_type,
        # service_name: :aliyun
      )
    end
    images.attach(blobs)
  end

  def image_url
    image.attached? ? image.url : nil
  end

  def image_urls
    images.attached? ? images.map(&:url) : []
  end

  def as_json(options = {})
    super(options).merge("image_url" => image_url, "image_urls" => image_urls)
  end



  # # local
  # has_one_attached :image, service: :local
  #   def image_url
  #     return nil unless image.attached?
  #     Rails.application.routes.url_helpers.rails_blob_path(image, only_path: true)
  #   end

  #   def as_json(options = {})
  #     super(options).merge("image_url" => image_url)
  #   end
end
