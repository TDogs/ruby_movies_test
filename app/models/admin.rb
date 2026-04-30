# app/models/admin.rb
class Admin < ApplicationRecord
  self.table_name = "admin"

  belongs_to :admin_power, class_name: "AdminPower", foreign_key: :role, primary_key: :id, optional: true
  default_scope { includes(:admin_power) }

  def getInfoAndMenus(jwt_payload = {})
    jwt_data = jwt_payload.to_h.with_indifferent_access
    role_id = jwt_data[:role].presence || role

    power = AdminPower.find_by(id: role_id)
    return [] if power.blank?
    puts " ================== power: #{power} ================== "

    # 拿到所有 menu_id 字符串 转换为数组
    menu_ids = power.menu_id.to_s
                    .split(",")
                    .map(&:strip)
                    .reject(&:blank?)
                    .map(&:to_i)
                    .uniq
    return [] if menu_ids.empty?
    puts " ================== menu_ids: #{menu_ids} ================== "

    # 查菜单 转数组
    menu_records = AdminMenu.where(id: menu_ids).where(status: 1).order(sort_order: :asc).to_a
puts " ================== menu_records: #{menu_records} ================== "
    #  构建树
    grouped = menu_records.group_by(&:parent_m_id)
puts " ================== grouped: #{grouped} ================== "

    # 递归构建
    build_tree = lambda do |parent_id|
      (grouped[parent_id] || []).map do |menu|
        {
          id: menu.id,
          title: menu.title,
          path: menu.path,
          icon: menu.icon,
          children: build_tree.call(menu.id)
        }
      end
    end

    {
      "username": jwt_data[:username],
      "avatar": "",
      "permissions": [ "admin" ], # 后期修改
      "menus": build_tree.call(nil)
    }
  end
end
