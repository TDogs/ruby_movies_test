class SimplifyMoviesColumns < ActiveRecord::Migration[8.1]
  def up
    return unless column_exists?(:movies, :actors_names)

    remove_index :movies, name: "index_movies_on_actors", if_exists: true
    remove_index :movies, name: "index_movies_on_actors_names", if_exists: true
    remove_index :movies, name: "index_movies_on_categories", if_exists: true
    remove_index :movies, name: "index_movies_on_directors", if_exists: true

    add_column :movies, :categories_str, :string, null: false, default: ""
    execute <<~SQL.squish
      UPDATE movies SET categories_str = COALESCE(array_to_string(categories, ','), '')
    SQL
    remove_column :movies, :categories
    rename_column :movies, :categories_str, :categories

    add_column :movies, :directors_str, :string, null: false, default: ""
    execute <<~SQL.squish
      UPDATE movies SET directors_str = COALESCE(array_to_string(directors, ','), '')
    SQL
    remove_column :movies, :directors
    rename_column :movies, :directors_str, :directors

    add_column :movies, :actors_text, :text, null: false, default: "[]"
    execute <<~SQL.squish
      UPDATE movies SET actors_text = COALESCE(actors::text, '[]')
    SQL
    remove_column :movies, :actors_names
    remove_column :movies, :actors
    rename_column :movies, :actors_text, :actors

    set_movie_comments
    change_table_comment(:movies, "电影主数据（抓取自 ssr1.scrape.center）")
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end

  private

  def set_movie_comments
    {
      source_id: "抓取站点详情页数字 ID（/detail/:id），用于 upsert 去重",
      source_url: "详情页完整 URL，便于溯源",
      title: "片名",
      categories: "类型标签，英文逗号分隔，例如：剧情,爱情",
      region: "国家/地区",
      duration_minutes: "片长（分钟）",
      release_date: "上映日期",
      poster_url: "海报图片地址",
      drama: "剧情简介",
      directors: "导演姓名，英文逗号分隔",
      actors: "演员 JSON 文本，含姓名与角色，例如：[{\"name\":\"…\",\"role\":\"…\"}]",
      rating: "评分（一位小数）",
      created_at: "创建时间",
      updated_at: "更新时间"
    }.each do |column, comment|
      change_column_comment(:movies, column, comment)
    end
  end
end
