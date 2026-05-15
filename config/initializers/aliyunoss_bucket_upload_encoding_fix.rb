# frozen_string_literal: true

# 覆盖 原来的上传
# aliyunoss 0.2.4 里 Bucket#upload 触发 UTF-8 / ASCII-8BIT 混用错误。
Rails.application.config.to_prepare do
  begin
    require "aliyunoss"
  rescue LoadError
    next
  end

  next unless defined?(Aliyun::Oss::Bucket)

  Aliyun::Oss::Bucket.class_eval do
    def upload(data, path, options = {})
      # puts " ================== 上传数据: #{data} ================== "
      # puts " ================== 上传路径: #{path} ================== "
      # puts " ================== 上传选项: #{options} ================== "
      Aliyun::Oss::API.put_object(self, path, data, options).raise_unless(Net::HTTPOK)
    end
  end
end
