require "net/http"

module ScrapeCenter
  class HttpClient
    # 作用：
    # - 统一 HTTP GET 请求（超时、UA、错误处理）
    # - 爬虫逻辑只关心“拿到 HTML 字符串”，不关心底层网络细节
    DEFAULT_OPEN_TIMEOUT = 8
    DEFAULT_READ_TIMEOUT = 15

    def initialize(base_url: "https://ssr1.scrape.center", open_timeout: DEFAULT_OPEN_TIMEOUT, read_timeout: DEFAULT_READ_TIMEOUT)
      @base_url = base_url
      @open_timeout = open_timeout
      @read_timeout = read_timeout
    end

    def get(path)
      uri = URI.join(@base_url, path)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = uri.scheme == "https"
      http.open_timeout = @open_timeout
      http.read_timeout = @read_timeout

      request = Net::HTTP::Get.new(uri)
      request["User-Agent"] = "rails_test_scraper/1.0 (+https://ssr1.scrape.center)"
      request["Accept"] = "text/html,application/xhtml+xml"

      response = http.request(request)
      unless response.is_a?(Net::HTTPSuccess)
        raise "HTTP #{response.code} when GET #{uri}"
      end

      response.body
    end
  end
end

