return unless defined?(ConnectionPool::TimedStack)

# Sidekiq 7.x 在内部会调用 timed_stack.pop(timeout)（位置参数）。
# connection_pool 3.x 的 `TimedStack#pop` 使用 keyword args：`pop(timeout: 0.5, ...)`
# Ruby 3 会把位置参数当成“多给了一个参数”，导致 scheduler 线程崩溃：
# `wrong number of arguments (given 1, expected 0)`
#
# 这里做兼容：允许位置参数 timeout，并转换成 keyword timeout。
ConnectionPool::TimedStack.class_eval do
  alias_method :pop_without_positional_timeout, :pop

  def pop(timeout = nil, **kwargs)
    return pop_without_positional_timeout(**kwargs) if timeout.nil?

    pop_without_positional_timeout(timeout: timeout, **kwargs)
  end
end

