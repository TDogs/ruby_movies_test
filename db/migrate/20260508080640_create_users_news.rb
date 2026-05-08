class CreateUsersNews < ActiveRecord::Migration[8.1]
  def change
    create_table :users_new do |t|
      t.string :email
      t.string :password_digest, null: false
      t.string :phone
      t.integer :status, default: 0, null: false
      t.string :username, null: false

      t.timestamps
    end
  end
end
