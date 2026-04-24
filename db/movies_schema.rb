module MoviesSchema
  module_function

  def ensure!(connection: ActiveRecord::Base.connection)
    unless connection.table_exists?(:movies)
      connection.create_table :movies, comment: "电影主数据" do |t|
        t.integer :source_id, null: false, comment: "站点详情页数字 ID"
        t.text :source_url, null: false, comment: "详情页完整 URL"

        t.string :title, null: false, comment: "片名"
        t.jsonb :categories, null: false, default: [], comment: "类型标签"
        t.string :region, comment: "国家/地区"
        t.integer :duration_minutes, comment: "片长（分钟）"
        t.date :release_date, comment: "上映日期"
        t.text :poster_url, comment: "海报图片地址"
        t.text :drama, comment: "剧情简介"
        t.jsonb :directors, null: false, default: [], comment: "导演姓名"
        t.jsonb :actors, null: false, default: [], comment: "演员列表"
        t.jsonb :subtitle, null: false, default: [], comment: "剧照图片地址"
        t.decimal :rating, precision: 3, scale: 1, comment: "评分（一位小数）"

        t.timestamps
      end
      
      # t.timestamps 不会自动带 
      connection.change_column_comment :movies, :created_at, "创建时间"
      connection.change_column_comment :movies, :updated_at, "更新时间"
    end

    
    # - 确保是否有索引 如果有就跳过 没有就创建
    connection.add_index(:movies, :source_id, unique: true) unless connection.index_exists?(:movies, :source_id, unique: true)
    %i[categories directors actors].each do |column|
      connection.add_index(:movies, column, using: :gin) unless connection.index_exists?(:movies, column) # 给 categories directors actors 创建 GIN 索引 支持json查询
    end
  end
end

