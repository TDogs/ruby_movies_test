class ConvertMoviesToJsonb < ActiveRecord::Migration[8.1]
  # 目的：
  # - 把 movies 的“多值字段”统一改为 PostgreSQL 原生 jsonb
  #   - categories：jsonb 数组（字符串数组）
  #   - directors：jsonb 数组（字符串数组）
  #   - actors：jsonb 数组（对象数组，包含 name/role/image 等）
  #
  # 为什么：
  # - jsonb + GIN 索引能用 `@>` 做“元素级包含”查询（语义清晰，SQL 简洁）
  # - 不再依赖 text 字符串解析/ILIKE 子串匹配（避免误匹配）
  def up
    return unless table_exists?(:movies)

    remove_index :movies, :categories, if_exists: true
    remove_index :movies, :directors, if_exists: true
    remove_index :movies, :actors, if_exists: true

    # categories: string(逗号分隔) -> jsonb(字符串数组)
    if column_exists?(:movies, :categories) && column_type(:movies, :categories) != :jsonb
      add_column :movies, :categories_jsonb, :jsonb, null: false, default: []
      execute <<~SQL.squish
        UPDATE movies
        SET categories_jsonb =
          to_jsonb(
            ARRAY(
              SELECT btrim(x)
              FROM unnest(string_to_array(COALESCE(categories, ''), ',')) AS x
              WHERE btrim(x) <> ''
            )
          )
      SQL
      remove_column :movies, :categories
      rename_column :movies, :categories_jsonb, :categories
    end

    # directors: string(逗号分隔) -> jsonb(字符串数组)
    if column_exists?(:movies, :directors) && column_type(:movies, :directors) != :jsonb
      add_column :movies, :directors_jsonb, :jsonb, null: false, default: []
      execute <<~SQL.squish
        UPDATE movies
        SET directors_jsonb =
          to_jsonb(
            ARRAY(
              SELECT btrim(x)
              FROM unnest(string_to_array(COALESCE(directors, ''), ',')) AS x
              WHERE btrim(x) <> ''
            )
          )
      SQL
      remove_column :movies, :directors
      rename_column :movies, :directors_jsonb, :directors
    end

    # actors: text(JSON 字符串) -> jsonb(对象数组)
    if column_exists?(:movies, :actors) && column_type(:movies, :actors) != :jsonb
      add_column :movies, :actors_jsonb, :jsonb, null: false, default: []
      execute <<~SQL.squish
        UPDATE movies
        SET actors_jsonb =
          CASE
            WHEN actors IS NULL OR btrim(actors) = '' THEN '[]'::jsonb
            ELSE actors::jsonb
          END
      SQL
      remove_column :movies, :actors
      rename_column :movies, :actors_jsonb, :actors
    end

    # GIN：用于 jsonb 的 `@>` 包含查询加速
    add_index :movies, :categories, using: :gin
    add_index :movies, :directors, using: :gin
    add_index :movies, :actors, using: :gin

    change_column_comment :movies, :categories, "类型标签（jsonb 数组，例如：[\"剧情\",\"爱情\"]）"
    change_column_comment :movies, :directors, "导演姓名（jsonb 数组，例如：[\"张艺谋\",\"…\"]）"
    change_column_comment :movies, :actors, "演员列表（jsonb 数组，对象含 name/role/image 等）"
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end

  private

  # Rails 8.1 没有公开 column_type 的快捷方法，这里用 columns 来判断
  def column_type(table, column)
    connection.columns(table).find { |c| c.name == column.to_s }&.type
  end
end

