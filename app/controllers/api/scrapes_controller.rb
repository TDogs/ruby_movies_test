module Api
  class ScrapesController < BaseController
    # 爬取接口（异步队列 / 后台任务）
    #
    # 作用：
    # - 只负责“入队”（enqueue），立即返回，不在 HTTP 请求里做任何爬取
    # - 由 ActiveJob + Solid Queue 在后台执行真正的抓取任务
    # - 实际抓取会被拆分为：1 个“调度 Job” + N 个“单页抓取 Job”
    #
    # 请求：
    # POST /api/scrape/movies
    # {
    #   "start_page": 1,
    #   "end_page": 10
    # }
    #
    # 返回：
    # - job_id：调度 Job 的 ActiveJob id（用于日志/排查/对照 solid_queue 记录）
    # - enqueued_range：本次入队的页码范围
    def movies
      start_page = params.fetch(:start_page, 1).to_i
      end_page = params.fetch(:end_page, start_page).to_i

      if start_page < 1 || end_page < start_page
        return render_error(message: "Invalid page range. Expect start_page >= 1 and end_page >= start_page.")
      end

      job = ScrapeCenter::EnqueueMoviesCrawlJob.perform_later(start_page:, end_page:)

      render_json(
        data: {
          job_id: job.job_id,
          enqueued_range: { start_page:, end_page: }
        }
      )
    end
  end
end

