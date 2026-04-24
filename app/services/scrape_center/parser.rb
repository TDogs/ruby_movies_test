require "nokogiri"
# script删除末尾空格 换行等
# text 返回纯文本 不包含末尾空格 换行等
# at_css css选择器 返回第一个匹配的元素
# css css选择器 返回所有匹配的元素
# filter_map 返回所有匹配的元素 并过滤掉 nil
# to_s 返回字符串
# to_i 返回整数
# to_f 返回浮点数
# to_json 返回 JSON 字符串
# to_date 返回日期
# to_time 返回时间

module ScrapeCenter
  class Parser
    # 解析列表页（/page/:n）
    # 实际只需要解析详情页 即可获得所有需要的信息 这里暂做，
    # 返回：
    # [
    #   { source_id:, title:, categories:（jsonb 数组）, region:, duration_minutes:, release_date:, poster_url:, rating:, source_url: }
    # ]
    def parse_list_page(html)
      doc = Nokogiri::HTML(html)

      doc.css("#index .el-card.item").filter_map do |item|
        detail_href = item.at_css("a[href^='/detail/']")&.[]("href").to_s
        source_id = detail_href.split("/").last.to_i
        next if source_id <= 0

        title = item.at_css("a.name h2")&.text&.strip.to_s
        poster_url = item.at_css("img.cover")&.[]("src")&.strip
        rating = item.at_css("p.score")&.text&.strip

        category_names = item.css(".categories .category span").map { |n| n.text.strip }.reject(&:blank?)

        info_spans = item.css(".info").map { |n| n.text.strip }.reject(&:blank?)
        # 第一行 info: "中国内地、中国香港 / 171 分钟"
        region, duration_minutes = parse_region_and_duration(info_spans[0].to_s)
        # 第二行 info: "1993-07-26 上映"
        release_date = parse_release_date(info_spans[1].to_s)

        {
          source_id:,
          source_url: "https://ssr1.scrape.center/detail/#{source_id}",
          title:,
          # categories 用“字符串数组”，后续直接写入 jsonb 列
          categories: category_names,
          region:,
          duration_minutes:,
          release_date:,
          poster_url:,
          rating: rating.present? ? BigDecimal(rating) : nil
        }
      end
    end

    # 解析详情页（/detail/:id）
    # 主要解析 详情页的相关信息 并返回
    def parse_detail_page(html)
      doc = Nokogiri::HTML(html)

      drama = doc.at_css("#detail .drama p")&.text&.strip

      # 导演
      directors = doc.css("#detail .directors .director").filter_map do |node|
        name = node.at_css(".name")&.text&.strip
        image = node.at_css(".image")&.attr("src")&.strip
        next if name.blank? # 如果名字都是空的话 直接跳过

        { "name" => name, "image" => image }
          # 删除nil数据 返回数组
        end.compact
        
      # 演员
      actors = doc.css("#detail .actors .actor").map do |node|
        name = node.at_css(".name")&.text&.strip
        role = node.at_css(".role")&.text&.strip
        image = node.at_css(".image")&.attr("src")&.strip
        next if name.blank?

        { "name" => name, "role" => role, "image" => image }
      end.compact

      # 剧照
      subtitle = doc.css("#detail .photos .photo img").filter_map do |img|
        img["src"]&.strip
      end

      # puts "-------------------------------- 当前剧照页 items: #{subtitle} --------------------------------"
      # puts "-------------------------------- 当前返回 actors: #{actors} --------------------------------"
      {
        drama:,
        directors:,
        actors:,
        subtitle:
      }
    end

    private

    def parse_region_and_duration(text)
      # text 形如："中国内地、中国香港 / 171 分钟"
      parts = text.split("/").map(&:strip)
      region = parts[0].presence

      duration_text = parts[1].to_s
      duration_minutes = duration_text[/\d+/].to_i
      duration_minutes = nil if duration_minutes <= 0

      [ region, duration_minutes ]
    end

    def parse_release_date(text)
      # text 形如："1993-07-26 上映"
      date_str = text.to_s.strip.split.first
      return nil if date_str.blank?

      Date.parse(date_str)
    rescue ArgumentError
      nil
    end
  end
end
