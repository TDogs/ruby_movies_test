module ScrapeCenter
  class EnqueueMoviesCrawlJob < ApplicationJob
    # 电影抓取任务的 循环任务 传递给子任务
    queue_as :scrape_center

    # - start_page: 起始页
    # - end_page: 结束页
    def perform(start_page:, end_page:)
      puts " ================== 当前开始页: #{start_page} 结束页: #{end_page} ================== "

      (start_page..end_page).each do |page|
        ScrapeCenter::CrawlMoviesPageJob.perform_later(page:)
        sleep (0.5) # 避免过快
      end

      puts " ================== 循环从第 #{start_page} 到第 #{end_page} 结束 ================== "
    end
  end
end
