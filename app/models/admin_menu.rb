class AdminMenu < ApplicationRecord
  # enum status: { draft: 0, published: 1, archived: 2 }  旧风格 不支持


  enum :status, { draft: 0, published: 1, archived: 2 }
end
