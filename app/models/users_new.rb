class UsersNew < ApplicationRecord
  self.table_name = "users_new"

  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }
end
