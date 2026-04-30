## 表迁移：
```
bin/rails db:migrate:queue
bin/rails db:migrate:cache
bin/rails db:migrate:cable
```

## 启动（Web + Worker）
```
bin/dev
```

## 队列 切换db 和 redis

```gemfile 增加
gem "sidekiq", "< 8"    可选 <8，若 >=8 redis要大于7，反之大于6

bundle install

手动执行：
JOBS_BACKEND=sidekiq bin/dev

切回db：JOBS_BACKEND=solid_queue bin/dev

bin/dev执行：
修改 config/environments/development.rb 下的 config.active_job.queue_adapter = :sidekiq【db=solid_queue】

redis下 需要手动显示的增加监听队列，在config/sideiq.yml中
```