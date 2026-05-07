class CreateAdminNews < ActiveRecord::Migration[8.1]
  def change
    create_table :admin_news do |t|
      t.string :email, comment: "邮箱"
      t.text :password, comment: "密码", null: false
      t.string :phone, comment: "手机号", null: false
      t.text :remark, comment: "备注"
      t.integer :role, comment: "角色", default: 0, null: false
      t.integer :status, comment: "状态", default: 0, null: false
      t.string :username, comment: "用户名", null: false

      t.timestamps
    end
    add_index :admin_news, :phone, unique: true unless index_exists?(:admin_news, :phone)


    change_column_comment :admin_news, :created_at, null: false
    change_column_comment :admin_news, :updated_at, null: true
  end
end
