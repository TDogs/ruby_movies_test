# app/models/admin_power.rb
class AdminPower < ApplicationRecord
  # 反查：Admin 表用 role 列引用本表 id
  has_many :admins, class_name: "Admin", foreign_key: :role, primary_key: :id
end
