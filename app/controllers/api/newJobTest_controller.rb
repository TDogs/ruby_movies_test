module Api
  class NewJobTestController < BaseController
    def index
      NewTestJob.perform_later({ name: "test" })
      render json: { message: "Job enqueued" }
    end
  end
end
