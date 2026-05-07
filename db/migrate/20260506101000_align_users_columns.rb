class AlignUsersColumns < ActiveRecord::Migration[8.1]
  def up
    return unless table_exists?(:users)

    remove_index :users, :email, if_exists: true

    if column_exists?(:users, :email) && !column_exists?(:users, :username)
      rename_column :users, :email, :username
    end

    add_column :users, :password_digest, :string unless column_exists?(:users, :password_digest)
    add_column :users, :created_at, :datetime, null: true unless column_exists?(:users, :created_at)
    add_column :users, :updated_at, :datetime, null: true unless column_exists?(:users, :updated_at)

    remove_index :users, :username, if_exists: true
    add_index :users, :username, unique: true

    change_column_null :users, :username, false
    if connection.select_value("SELECT COUNT(*) FROM users").to_i.zero?
      change_column_null :users, :password_digest, false
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
