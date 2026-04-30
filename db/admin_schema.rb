

module AdminSchema
  module_function

  def ensure!(connection: ActiveRecord::Base.connection)
    ensure_admin_powers_table!(connection)
    ensure_admin_table!(connection)
    ensure_admin_menus_table!(connection)
  end

  def ensure_admin_table!(connection)
    return if connection.table_exists?(:admin)

    connection.create_table :admin, comment: "后台管理员" do |t|
      t.text :password, null: false, comment: "密码"
      t.string :username, null: false, comment: "用户名"
      t.string :email, comment: "邮箱"
      t.string :phone,  comment: "手机号"
      t.integer :role, limit: 2, null: false, default: 0, comment: "角色"
      t.integer :status, limit: 2, null: false, default: 0, comment: "状态"
      t.string :remark, comment: "备注"
      t.timestamps null: true
    end

    connection.change_column_comment :admin, :created_at, "创建时间"
    connection.change_column_comment :admin, :updated_at, "更新时间"
  end

  def ensure_admin_menus_table!(connection)
    return if connection.table_exists?(:admin_menus)

    connection.create_table :admin_menus, comment: "后台菜单" do |t|
      t.bigint :parent_m_id, comment: "父菜单id"
      t.string :title, null: false, comment: "菜单名称"
      t.string :path, null: false, comment: "菜单路径"
      t.string :icon, comment: "菜单图标"
      t.boolean :keep_alive, null: false, default: false, comment: "页面是否保持状态"
      t.integer :sort_order, null: false, default: 0, comment: "菜单排序"
      t.boolean :show, null: false, default: true, comment: "是否显示在菜单上"
      t.bigint :created_admin, null: false, comment: "创建者id"
      t.integer :status, limit: 2, null: false, default: 0, comment: "状态 1显示 0隐藏"
      t.boolean :is_deleted, null: false, default: false, comment: "是否删除"
      t.timestamps null: true
    end

    connection.change_column_comment :admin_menus, :created_at, "创建时间"
    connection.change_column_comment :admin_menus, :updated_at, "更新时间"
    connection.add_index :admin_menus, :parent_m_id unless connection.index_exists?(:admin_menus, :parent_m_id)
    connection.add_index :admin_menus, :path, unique: true unless connection.index_exists?(:admin_menus, :path, unique: true)
  end

  def ensure_admin_powers_table!(connection)
    return if connection.table_exists?(:admin_powers)

    connection.create_table :admin_powers, comment: "后台权限" do |t|
      t.string :name, null: false, comment: "权限名称"
      t.string :menu_id, null: false, comment: "菜单id"
      t.integer :status, limit: 2, null: false, default: 0, comment: "状态"
      t.timestamps null: true
    end

    connection.change_column_comment :admin_powers, :created_at, "创建时间"
    connection.change_column_comment :admin_powers, :updated_at, "更新时间"
    connection.add_index :admin_powers, :menu_id unless connection.index_exists?(:admin_powers, :menu_id)
  end

end

