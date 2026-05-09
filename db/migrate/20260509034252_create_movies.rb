class CreateMovies < ActiveRecord::Migration[8.1]
  def change
    create_table :movies do |t|
      t.jsonb :actors, default: [], null: false, comment: "演员列表（jsonb 数组，对象含 name/role/image 等）"
      t.jsonb :categories, default: [], null: false, comment: "类型标签（jsonb 数组，例如：[\"剧情\",\"爱情\"]）"
      t.jsonb :directors, default: [], null: false, comment: "导演姓名（jsonb 数组）"
      t.string :drama, comment: "剧情简介"
      t.integer :duration_minutes, index: true, comment: "片长（分钟）"
      t.integer :is_deleted, default: 0, null: false, comment: "0否 1是"
      t.string :poster_url, comment: "海报图片地址"
      t.decimal :rating, precision: 2, scale: 1, null: false, comment: "评分（一位小数）"
      t.string :region, comment: "国家/地区"
      t.date :release_date, index: true, comment: "上映日期"
      t.integer :source_id, null: false, comment: "站点详情页数字 ID（/detail/:id），用于 upsert 去重"
      t.text :source_url, null: false, comment: "详情页完整 URL，便于溯源"
      t.jsonb :subtitle, default: [], null: false, comment: "剧照图片地址"
      t.string :title, index: true, comment: "片名"

      t.timestamps
    end
  end
end
