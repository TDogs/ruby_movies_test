module ScrapeCenter
  class CrawlMoviesPageJob < ApplicationJob
    # 电影抓取任务的 “按照单页执行” 任务（真正做 HTTP 抓取 + 数据入库）。
    queue_as :scrape_center

    # - 抓取某一页的电影列表
    # - 对列表里的每一部电影抓详情
    # - 把数据 upsert 写入 PG
    # def perform(page:)
      puts " ================== 当前第#{page}页 开始处理 ================== "

      # 真正执行爬取 组装数据 并返回的方法
      crawler = ScrapeCenter::Crawler.new
      movies = crawler.crawl_page(page)

      # 判断是否有数据 并一次写入
      if movies.empty?
        # puts " ================== 当前没有数据 ================== "
        return
      end

      # puts " ================== 当前写入的数据: #{movies} ================== "
      begin
        ActiveRecord::Base.connection.schema_cache.clear!

        result =
          Movie.upsert_all(
            movies,
            unique_by: :index_movies_on_source_id,
            record_timestamps: true,
            # 接受返回
            returning: %w[source_id]
          )

        upserted_source_ids = Array(result&.rows).flatten.compact
        # puts " ================== upsert_all 成功 returning_count=#{upserted_source_ids.length} source_ids=#{upserted_source_ids.first(8)} ================== "
      rescue => e
        # puts " ================== upsert_all 失败 class=#{e.class} message=#{e.message} ================== "
        puts e.backtrace.first(12).join("\n")
        raise
      end

      # puts " ================== 当前第#{page}页 处理完成 写入数据#{movies.length}条 ================== "
    end
  end
end
