# app/models/admin_power.rb
class AdminPower < ApplicationRecord
  has_many :admins, class_name: "Admin", foreign_key: :role, primary_key: :id
end
