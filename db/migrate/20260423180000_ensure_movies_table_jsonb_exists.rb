class EnsureMoviesTableJsonbExists < ActiveRecord::Migration[8.1]
  # 目的：
  # - 解决“迁移状态是 up，但库里实际没有 movies 表”的情况（例如手动删表/重建库）
  # - 若 movies 表缺失：按当前约定的 jsonb 结构重建，并补齐必要索引
  def up
    unless table_exists?(:movies)
      create_table :movies, comment: "电影主数据（抓取自 ssr1.scrape.center）" do |t|
        t.integer :source_id, null: false, comment: "站点详情页数字 ID（/detail/:id），用于 upsert 去重"
        t.text :source_url, null: false, comment: "详情页完整 URL，便于溯源"

        t.string :title, null: false, comment: "片名"
        t.jsonb :categories, null: false, default: [], comment: "类型标签（jsonb 数组，例如：[\"剧情\",\"爱情\"]）"
        t.string :region, comment: "国家/地区"
        t.integer :duration_minutes, comment: "片长（分钟）"
        t.date :release_date, comment: "上映日期"
        t.text :poster_url, comment: "海报图片地址"
        t.text :drama, comment: "剧情简介"
        t.jsonb :directors, null: false, default: [], comment: "导演姓名（jsonb 数组）"
        t.jsonb :actors, null: false, default: [], comment: "演员列表（jsonb 数组，对象含 name/role/image 等）"
        t.decimal :rating, precision: 3, scale: 1, comment: "评分（一位小数）"

        t.timestamps
      end

      change_column_comment :movies, :created_at, "创建时间"
      change_column_comment :movies, :updated_at, "更新时间"
    end

    add_index :movies, :source_id, unique: true unless index_exists?(:movies, :source_id, unique: true)
    add_index :movies, :title unless index_exists?(:movies, :title)
    add_index :movies, :region unless index_exists?(:movies, :region)
    add_index :movies, :duration_minutes unless index_exists?(:movies, :duration_minutes)
    add_index :movies, :release_date unless index_exists?(:movies, :release_date)
    add_index :movies, :rating unless index_exists?(:movies, :rating)

    add_index :movies, :categories, using: :gin unless index_exists?(:movies, :categories)
    add_index :movies, :directors, using: :gin unless index_exists?(:movies, :directors)
    add_index :movies, :actors, using: :gin unless index_exists?(:movies, :actors)
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end

