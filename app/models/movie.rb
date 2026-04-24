class Movie < ApplicationRecord
  self.table_name = "movies"  # 显示表名
  # 验证 根据 source_id
  validates :source_id, presence: true, uniqueness: { case_sensitive: true, message: "已存在" }


  # 查询构建条件
  def self.filter(params)
    scope = all

    # 片名
    # sanitize_sql_like 进行参数转义
    if params[:title].present?
      scope = scope.where("title ILIKE ?", "%#{sanitize_sql_like(params[:title])}%")
    end

    # 地区：模糊匹配
    if params[:region].present?
      scope = scope.where("region ILIKE ?", "%#{sanitize_sql_like(params[:region])}%")
    end

    # 时长
    if params[:duration_minutes_from].present?
      
      scope = scope.where("duration_minutes >= ?", params[:duration_minutes_from].to_i)
    end

    # 时长
    if params[:duration_minutes_to].present?
      scope = scope.where("duration_minutes <= ?", params[:duration_minutes_to].to_i)
    end
    # --- 上映日：开始
    if params[:release_date_from].present?
      scope = scope.where("release_date >= ?", Date.parse(params[:release_date_from]))
    end

    # --- 上映日：结束
    if params[:release_date_to].present?
      scope = scope.where("release_date <= ?", Date.parse(params[:release_date_to]))
    end


    # jsonb类型下？=或，@> 包含查询 必须加::jsonb 可能索引实效
    
    # 类型标签  jsonb 数组包含查询
    categories = split_csv(params[:categories].presence || params[:category])
    if categories.any?
      scope = scope.where("categories @> ?::jsonb", categories.to_json)
    end

    # 导演：jsonb 数组包含查询【和标签写法不一样 ，标签是and查询 导演这里暂时用or查询】
    directors = split_csv(params[:directors].presence || params[:director])
    if directors.any?
      # `?|`：jsonb 是否包含“任意一个”字符串元素（OR 语义）
      scope = scope.where("directors ?| array[:names]", names: directors)
    end

    # 演员：jsonb 对象数组“存在某个对象”查询
    actors = split_csv(params[:actors].presence || params[:actor])
    actors.each do |name|
      scope = scope.where("actors @> ?::jsonb", [ { "name" => name } ].to_json)
    end

    # 评分 大于等于
    if params[:rating_min].present?
      scope = scope.where("rating >= ?", BigDecimal(params[:rating_min].to_s))
    end

    # 评分 小于等于
    if params[:rating_max].present?
      scope = scope.where("rating <= ?", BigDecimal(params[:rating_max].to_s))
    end

    # 主键排序
    scope.order(id: :desc)
  rescue ArgumentError
    # 返空
    none
  end

  # 参数过滤 字符串最终转数组
  def self.split_csv(str)
    return [] if str.blank?
  
    str.split(",").map(&:strip).reject(&:blank?).uniq # 去重 去掉空格 去掉空字符串
  end
  private_class_method :split_csv
end
