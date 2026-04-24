require_relative "../../db/movies_schema"

namespace :db do
  namespace :movies do
    desc "确保 movies 表存在（不存在则创建，并补齐索引/注释）"
    task ensure: :environment do
      MoviesSchema.ensure!
      puts "[db:movies:ensure] OK"
    end

    desc "重建 movies 表（DROP + CREATE + 索引/注释；会丢失 movies 数据）"
    task rebuild: :environment do
      MoviesSchema.rebuild!
      puts "[db:movies:rebuild] OK"
    end
  end
end

