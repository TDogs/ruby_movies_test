# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_05_14_094434) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.text "body"
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "admin_menus", force: :cascade do |t|
    t.bigint "created_admin", default: 0, null: false, comment: "创建者id"
    t.datetime "created_at", null: false
    t.string "icon", default: "", comment: "菜单图标"
    t.boolean "is_deleted", default: false, null: false, comment: "是否删除"
    t.boolean "keep_alive", default: false, null: false, comment: "页面是否保持状态"
    t.bigint "parent_m_id", default: 0, null: false, comment: "父菜单id"
    t.string "path", null: false, comment: "菜单路径"
    t.boolean "show", default: true, null: false, comment: "是否显示在菜单上"
    t.integer "sort_order", default: 0, null: false, comment: "菜单排序"
    t.integer "status", default: 0, null: false, comment: "状态 1显示 0隐藏"
    t.string "title", default: "", null: false, comment: "菜单名称"
    t.datetime "updated_at", null: false
    t.index ["created_admin"], name: "index_admin_menus_on_created_admin"
  end

  create_table "admin_menus_news", force: :cascade do |t|
    t.bigint "created_admin", default: 0, null: false, comment: "创建者id"
    t.datetime "created_at", null: false, comment: "创建时间"
    t.string "icon", default: "", comment: "菜单图标"
    t.boolean "is_deleted", default: false, null: false, comment: "是否删除"
    t.boolean "keep_alive", default: false, null: false, comment: "页面是否保持状态"
    t.bigint "parent_m_id", default: 0, null: false, comment: "父菜单id"
    t.string "path", null: false, comment: "菜单路径"
    t.boolean "show", default: true, null: false, comment: "是否显示在菜单上"
    t.integer "sort_order", default: 0, null: false, comment: "菜单排序"
    t.integer "status", default: 0, null: false, comment: "状态 1显示 0隐藏"
    t.string "title", default: "", null: false, comment: "菜单名称"
    t.datetime "updated_at", comment: "更新时间"
    t.index ["created_admin"], name: "index_admin_menus_news_on_created_admin"
  end

  create_table "admin_news", force: :cascade do |t|
    t.datetime "created_at", null: false, comment: "创建时间"
    t.string "email", comment: "邮箱"
    t.text "password_digest", null: false, comment: "密码"
    t.string "phone", null: false, comment: "手机号"
    t.text "remark", comment: "备注"
    t.integer "role", comment: "角色"
    t.integer "status", comment: "状态"
    t.datetime "updated_at", comment: "更新时间"
    t.string "username", null: false, comment: "用户名"
    t.index ["phone"], name: "index_admin_news_on_phone", unique: true
    t.index ["role"], name: "index_admin_news_on_role"
  end

  create_table "admin_powers", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "menu_id", null: false
    t.string "name"
    t.integer "status"
    t.datetime "updated_at", null: false
  end

  create_table "admin_powers_new", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "menu_id", null: false
    t.string "name"
    t.integer "status"
    t.datetime "updated_at", null: false
  end

  create_table "admins", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.integer "is_deleted", default: 0, null: false
    t.text "password_digest", null: false
    t.string "phone", null: false
    t.text "remark"
    t.integer "role", default: 0, null: false
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.string "username", null: false
    t.index ["username"], name: "ix_admins_username"
  end

  create_table "alembic_version", primary_key: "version_num", id: { type: :string, limit: 32 }, force: :cascade do |t|
  end

  create_table "comments", force: :cascade do |t|
    t.text "content"
    t.datetime "created_at", null: false
    t.bigint "post_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "userts_id", null: false
    t.index ["post_id"], name: "index_comments_on_post_id"
    t.index ["userts_id"], name: "index_comments_on_userts_id"
  end

  create_table "movies", force: :cascade do |t|
    t.jsonb "actors", default: [], null: false
    t.jsonb "categories", default: [], null: false
    t.datetime "created_at", null: false
    t.jsonb "directors", default: [], null: false
    t.string "drama"
    t.integer "duration_minutes"
    t.integer "is_deleted", default: 0, null: false
    t.string "poster_url"
    t.decimal "rating", precision: 2, scale: 1, null: false
    t.string "region"
    t.date "release_date"
    t.integer "source_id", null: false
    t.text "source_url", null: false
    t.jsonb "subtitle", default: [], null: false
    t.string "title"
    t.datetime "updated_at", null: false
  end

  create_table "movies_copy1", id: :bigint, default: -> { "nextval('movies_id_seq'::regclass)" }, force: :cascade do |t|
    t.jsonb "actors", default: [], null: false, comment: "演员列表（jsonb 数组，对象含 name/role/image 等）"
    t.jsonb "categories", default: [], null: false, comment: "类型标签（jsonb 数组，例如：[\"剧情\",\"爱情\"]）"
    t.datetime "created_at", null: false
    t.jsonb "directors", default: [], null: false, comment: "导演姓名（jsonb 数组）"
    t.string "drama", comment: "剧情简介"
    t.integer "duration_minutes", comment: "片长（分钟）"
    t.integer "is_deleted", default: 0, null: false, comment: "0否 1是"
    t.string "poster_url", comment: "海报图片地址"
    t.decimal "rating", precision: 2, scale: 1, null: false, comment: "评分（一位小数）"
    t.string "region", comment: "国家/地区"
    t.date "release_date", comment: "上映日期"
    t.integer "source_id", null: false, comment: "站点详情页数字 ID（/detail/:id），用于 upsert 去重"
    t.text "source_url", null: false, comment: "详情页完整 URL，便于溯源"
    t.jsonb "subtitle", default: [], null: false, comment: "剧照图片地址"
    t.string "title", comment: "片名"
    t.datetime "updated_at", null: false
    t.index ["duration_minutes"], name: "index_movies_on_duration_minutes_copy1"
    t.index ["release_date"], name: "index_movies_on_release_date_copy1"
    t.index ["title"], name: "index_movies_on_title_copy1"
  end

  create_table "movies_new", force: :cascade do |t|
    t.jsonb "actors", default: [], null: false, comment: "演员列表（jsonb 数组，对象含 name/role/image 等）"
    t.jsonb "categories", default: [], null: false, comment: "类型标签（jsonb 数组，例如：[\"剧情\",\"爱情\"]）"
    t.datetime "created_at", null: false
    t.jsonb "directors", default: [], null: false, comment: "导演姓名（jsonb 数组）"
    t.string "drama", comment: "剧情简介"
    t.integer "duration_minutes", comment: "片长（分钟）"
    t.integer "is_deleted", default: 0, null: false, comment: "0否 1是"
    t.string "poster_url", comment: "海报图片地址"
    t.decimal "rating", precision: 2, scale: 1, null: false, comment: "评分（一位小数）"
    t.string "region", comment: "国家/地区"
    t.date "release_date", comment: "上映日期"
    t.integer "source_id", null: false, comment: "站点详情页数字 ID（/detail/:id），用于 upsert 去重"
    t.text "source_url", null: false, comment: "详情页完整 URL，便于溯源"
    t.jsonb "subtitle", default: [], null: false, comment: "剧照图片地址"
    t.string "title", comment: "片名"
    t.datetime "updated_at", null: false
    t.index ["duration_minutes"], name: "index_movies_new_on_duration_minutes"
    t.index ["release_date"], name: "index_movies_new_on_release_date"
    t.index ["title"], name: "index_movies_new_on_title"
  end

  create_table "posts", force: :cascade do |t|
    t.text "body"
    t.datetime "created_at", null: false
    t.string "title"
    t.datetime "updated_at", null: false
    t.bigint "usert_id", null: false
    t.index ["usert_id"], name: "index_posts_on_usert_id"
  end

  create_table "products", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.integer "inventory_count", default: 0, null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
  end

  create_table "request_logs", id: :serial, force: :cascade do |t|
    t.text "request", null: false
    t.text "response", null: false
    t.index ["id"], name: "ix_request_logs_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "solid_cache_entries", force: :cascade do |t|
    t.integer "byte_size", null: false
    t.datetime "created_at", null: false
    t.binary "key", null: false
    t.bigint "key_hash", null: false
    t.binary "value", null: false
    t.index ["byte_size"], name: "index_solid_cache_entries_on_byte_size"
    t.index ["key_hash", "byte_size"], name: "index_solid_cache_entries_on_key_hash_and_byte_size"
    t.index ["key_hash"], name: "index_solid_cache_entries_on_key_hash", unique: true
  end

  create_table "solid_queue_blocked_executions", force: :cascade do |t|
    t.string "concurrency_key", null: false
    t.datetime "created_at", null: false
    t.datetime "expires_at", null: false
    t.bigint "job_id", null: false
    t.integer "priority", default: 0, null: false
    t.string "queue_name", null: false
    t.index ["concurrency_key", "priority", "job_id"], name: "index_solid_queue_blocked_executions_for_release"
    t.index ["expires_at", "concurrency_key"], name: "index_solid_queue_blocked_executions_for_maintenance"
    t.index ["job_id"], name: "index_solid_queue_blocked_executions_on_job_id", unique: true
  end

  create_table "solid_queue_claimed_executions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "job_id", null: false
    t.bigint "process_id"
    t.index ["job_id"], name: "index_solid_queue_claimed_executions_on_job_id", unique: true
    t.index ["process_id", "job_id"], name: "index_solid_queue_claimed_executions_on_process_id_and_job_id"
  end

  create_table "solid_queue_failed_executions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "error"
    t.bigint "job_id", null: false
    t.index ["job_id"], name: "index_solid_queue_failed_executions_on_job_id", unique: true
  end

  create_table "solid_queue_jobs", force: :cascade do |t|
    t.string "active_job_id"
    t.text "arguments"
    t.string "class_name", null: false
    t.string "concurrency_key"
    t.datetime "created_at", null: false
    t.datetime "finished_at"
    t.integer "priority", default: 0, null: false
    t.string "queue_name", null: false
    t.datetime "scheduled_at"
    t.datetime "updated_at", null: false
    t.index ["active_job_id"], name: "index_solid_queue_jobs_on_active_job_id"
    t.index ["class_name"], name: "index_solid_queue_jobs_on_class_name"
    t.index ["finished_at"], name: "index_solid_queue_jobs_on_finished_at"
    t.index ["queue_name", "finished_at"], name: "index_solid_queue_jobs_for_filtering"
    t.index ["scheduled_at", "finished_at"], name: "index_solid_queue_jobs_for_alerting"
  end

  create_table "solid_queue_pauses", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "queue_name", null: false
    t.index ["queue_name"], name: "index_solid_queue_pauses_on_queue_name", unique: true
  end

  create_table "solid_queue_processes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "hostname"
    t.string "kind", null: false
    t.datetime "last_heartbeat_at", null: false
    t.text "metadata"
    t.string "name", null: false
    t.integer "pid", null: false
    t.bigint "supervisor_id"
    t.index ["last_heartbeat_at"], name: "index_solid_queue_processes_on_last_heartbeat_at"
    t.index ["name", "supervisor_id"], name: "index_solid_queue_processes_on_name_and_supervisor_id", unique: true
    t.index ["supervisor_id"], name: "index_solid_queue_processes_on_supervisor_id"
  end

  create_table "solid_queue_ready_executions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "job_id", null: false
    t.integer "priority", default: 0, null: false
    t.string "queue_name", null: false
    t.index ["job_id"], name: "index_solid_queue_ready_executions_on_job_id", unique: true
    t.index ["priority", "job_id"], name: "index_solid_queue_poll_all"
    t.index ["queue_name", "priority", "job_id"], name: "index_solid_queue_poll_by_queue"
  end

  create_table "solid_queue_recurring_executions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "job_id", null: false
    t.datetime "run_at", null: false
    t.string "task_key", null: false
    t.index ["job_id"], name: "index_solid_queue_recurring_executions_on_job_id", unique: true
    t.index ["task_key", "run_at"], name: "index_solid_queue_recurring_executions_on_task_key_and_run_at", unique: true
  end

  create_table "solid_queue_recurring_tasks", force: :cascade do |t|
    t.text "arguments"
    t.string "class_name"
    t.string "command", limit: 2048
    t.datetime "created_at", null: false
    t.text "description"
    t.string "key", null: false
    t.integer "priority", default: 0
    t.string "queue_name"
    t.string "schedule", null: false
    t.boolean "static", default: true, null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_solid_queue_recurring_tasks_on_key", unique: true
    t.index ["static"], name: "index_solid_queue_recurring_tasks_on_static"
  end

  create_table "solid_queue_scheduled_executions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "job_id", null: false
    t.integer "priority", default: 0, null: false
    t.string "queue_name", null: false
    t.datetime "scheduled_at", null: false
    t.index ["job_id"], name: "index_solid_queue_scheduled_executions_on_job_id", unique: true
    t.index ["scheduled_at", "priority", "job_id"], name: "index_solid_queue_dispatch_all"
  end

  create_table "solid_queue_semaphores", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "expires_at", null: false
    t.string "key", null: false
    t.datetime "updated_at", null: false
    t.integer "value", default: 1, null: false
    t.index ["expires_at"], name: "index_solid_queue_semaphores_on_expires_at"
    t.index ["key", "value"], name: "index_solid_queue_semaphores_on_key_and_value"
    t.index ["key"], name: "index_solid_queue_semaphores_on_key", unique: true
  end

  create_table "subscribers", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.bigint "product_id", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_subscribers_on_product_id"
  end

  create_table "t_attributes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "t_categories", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.integer "parent_id", default: 0, null: false
    t.datetime "updated_at", null: false
  end

  create_table "t_categories_attributes", force: :cascade do |t|
    t.integer "attribute_id", null: false
    t.integer "category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["attribute_id"], name: "index_t_categories_attributes_on_attribute_id"
    t.index ["category_id"], name: "index_t_categories_attributes_on_category_id"
  end

  create_table "t_goods", force: :cascade do |t|
    t.integer "category_id", null: false
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_t_goods_on_category_id"
  end

  create_table "t_goods_attribute_values", force: :cascade do |t|
    t.integer "attribute_id", null: false
    t.datetime "created_at", null: false
    t.integer "goods_id", null: false
    t.datetime "updated_at", null: false
    t.string "value"
    t.index ["attribute_id"], name: "index_t_goods_attribute_values_on_attribute_id"
    t.index ["goods_id"], name: "index_t_goods_attribute_values_on_goods_id"
  end

  create_table "test_uploads", force: :cascade do |t|
    t.text "body"
    t.datetime "created_at", null: false
    t.string "title"
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  create_table "users_new", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.string "password_digest", null: false
    t.string "phone"
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.string "username", null: false
  end

  create_table "users_old", id: :bigint, default: -> { "nextval('users_id_seq'::regclass)" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.string "password_digest"
    t.string "phone"
    t.integer "status"
    t.datetime "updated_at", null: false
    t.string "username"
  end

  create_table "userts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.string "name"
    t.datetime "updated_at", null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "comments", "posts"
  add_foreign_key "comments", "userts", column: "userts_id"
  add_foreign_key "posts", "userts"
  add_foreign_key "sessions", "users"
  add_foreign_key "solid_queue_blocked_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_claimed_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_failed_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_ready_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_recurring_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_scheduled_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "subscribers", "products"
  add_foreign_key "t_categories_attributes", "t_attributes", column: "attribute_id"
  add_foreign_key "t_categories_attributes", "t_categories", column: "category_id"
  add_foreign_key "t_goods", "t_categories", column: "category_id"
  add_foreign_key "t_goods_attribute_values", "t_attributes", column: "attribute_id"
  add_foreign_key "t_goods_attribute_values", "t_goods", column: "goods_id"
end
