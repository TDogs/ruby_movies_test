# app/models/admin_power.rb
class AdminPower < ApplicationRecord
  self.table_name = "admin_powers"

  has_many :admins, class_name: "Admin", foreign_key: :role, primary_key: :id
end
