class CreateAdmins < ActiveRecord::Migration[8.1]
  def change
    create_table :admins do |t|
      t.string :email, comment: "邮箱"
      t.text :password_digest, comment: "密码", null: false
      t.string :phone, comment: "手机号", null: false
      t.text :remark, comment: "备注"
      t.integer :role,  index: true, comment: "角色", default: 0, null: false
      t.integer :status, comment: "状态", default: 0, null: false
      t.string :username, comment: "用户名", null: false

      t.timestamps
    end
  end
end
