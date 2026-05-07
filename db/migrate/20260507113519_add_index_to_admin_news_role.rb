class AddIndexToAdminNewsRole < ActiveRecord::Migration[8.1]
  def change
    add_index :admin_news, :role
  end
end
