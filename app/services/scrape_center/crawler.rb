module ScrapeCenter
  class Crawler
    def initialize(client: HttpClient.new, parser: Parser.new)
      @client = client
      @parser = parser
    end

    # 输入：页码（整数）
    def crawl_page(page)
      # 打印当前到底爬到第几页、第几条数据
      puts "\n[ScrapeCenter] 开始爬取第 #{page} 页..."
      list_html = @client.get("/page/#{page}")
      items = @parser.parse_list_page(list_html)

      puts "-------------------------------- 当前页 items: #{items} --------------------------------"
      results = []
      items.each_with_index do |base_attrs, idx|
        begin
          detail_html = @client.get("/detail/#{base_attrs[:source_id]}")
          detail_attrs = @parser.parse_detail_page(detail_html)
      puts "-------------------------------- 当前详情页 items: #{detail_attrs} --------------------------------"

          movie_attrs = base_attrs.merge(detail_attrs)

      puts "-------------------------------- 当前合并页 items: #{movie_attrs} --------------------------------"

          results << movie_attrs



          # ✅ 终端实时打印（字段名与 Parser 输出保持一致）
          # - title：电影名
          # - rating：评分（BigDecimal 或 nil）
          # - region：地区
          # - categories：类型（逗号分隔字符串）
          title = movie_attrs[:title].to_s.strip
          title = "未知片名" if title.blank?
          title = title.truncate(20, omission: "\u2026")

          rating = movie_attrs[:rating]
          rating_str =
            if rating.respond_to?(:to_f)
              format("%.1f", rating.to_f)
            else
              "?"
            end

          region = movie_attrs[:region].to_s.strip.presence || "?"
          categories = movie_attrs[:categories].to_s.strip.presence || "?"

          puts "  ✓ [#{idx + 1}/#{items.length}] 《#{title}》 ★#{rating_str} | #{region} | #{categories}"
        rescue => e
          puts "  ⚠️ [#{idx + 1}/#{items.length}] 解析失败（ID: #{base_attrs[:source_id]}）: #{e.message}"
          next
        end
      end

      puts "[ScrapeCenter] 第 #{page} 页完成：共 #{results.length}/#{items.length} 条有效数据"
      results
    end
  end
end
