class AddSubtitleToMovies < ActiveRecord::Migration[8.1]
  def change
    return unless table_exists?(:movies)
    return if column_exists?(:movies, :subtitle)

    add_column :movies, :subtitle, :jsonb, null: false, default: [], comment: "剧照图片地址"
  end
end

