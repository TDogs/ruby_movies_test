class Category < ApplicationRecord
  self.table_name = "t_categories"
  has_many :goods # 获取多个商品

  # 分类与中间表的关联，得到该分类下的多条 所属 categories_attributes 记录
  has_many :categories_attributes, inverse_of: :category

  # 获取多个属性信息 中间表中找到对应的属性id 再通过属性id找到对应的属性【through: :categories_attributes => categories_attributes， source: :attr => attr】
  has_many :attrs, through: :categories_attributes, source: :attr

  def self.filter(params)
    scope = all
    if params[:name].present?
      scope = scope.where("name ILIKE ?", "%#{sanitize_sql_like(params[:name])}%")
    end

    if params[:level].present?
      if params[:level] == "1"
        scope = scope.where(parent_id: 0)
      else
        scope = scope.where("parent_id > 0")
      end
    end
    scope
  end
  # 树形列表
  # 1) group_by(&:parent_id) 把「同一父 id」下的行放一组（key 为 0 的就是顶级）。
  # 2) build 递归：对某个 pid 取这一组，每个节点再用自己的 id 作为子层的 pid 调 build，直到没有子节点得到 []。
  # def self.tree_for_select
  #   grouped = all.group_by(&:parent_id)
  #   build = lambda do |pid|
  #     (grouped[pid] || []).map do |c|
  #       { value: c.id, label: c.name, children: build.call(c.id) }
  #     end
  #   end
  #   build.call(0)
  # end
end
