class RenamePasswordOnAdminNews < ActiveRecord::Migration[8.1]
  def change
    rename_column :admin_news, :password, :password_digest
  end
end
