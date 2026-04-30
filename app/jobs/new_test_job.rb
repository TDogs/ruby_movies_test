class NewTestJob < ApplicationJob
  queue_as :default

  def perform(*args)
    puts " ================== 当前接收数据: #{args} ================== "
    # Do something later
  end
end
