class AdminPowersNew < ApplicationRecord
  self.table_name = "admin_powers_new"
  has_many :admins, class_name: "Admin", foreign_key: :role, primary_key: :id
end
