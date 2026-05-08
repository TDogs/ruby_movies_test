class CreateAdminMenusNews < ActiveRecord::Migration[8.1]
  def change
    create_table :admin_menus_news do |t|
      t.bigint :created_admin, index: true, default: 0, null: false, comment: "创建者id"
      t.string :icon, default: "", null: true, comment: "菜单图标"
      t.boolean :is_deleted, default: false, null: false, comment: "是否删除"
      t.boolean :keep_alive, default: false, null: false, comment: "页面是否保持状态"
      t.bigint :parent_m_id, default: 0, null: false, comment: "父菜单id"
      t.string :path, null: false, comment: "菜单路径"
      t.boolean :show, default: true, null: false, comment: "是否显示在菜单上"
      t.integer :sort_order, default: 0, null: false, comment: "菜单排序"
      t.integer :status, default: 0, null: false, comment: "状态 1显示 0隐藏"
      t.string :title, default: "", null: false, comment: "菜单名称"

      t.datetime :created_at, null: false, comment: "创建时间"
      t.datetime :updated_at, null: true,  comment: "更新时间"
      # t.timestamps
    end
  end
end
