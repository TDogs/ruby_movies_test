
class Attribute < ApplicationRecord
  self.table_name = "t_attributes"

  # 属性与中间表的关联，得到该属性下的多条 所属 categories_attributes 记录，1：找到和我有关的所有数据
  has_many :categories_attributes, inverse_of: :attr

  # 通过中间表拿到 Category 记录 这里不用source因为已经通过categories_attributes无需别名 2：通过1 找到所有相关联的分类
  has_many :categories, through: :categories_attributes


  # 再通过分类表找到所有相关联的商品
  has_many :goods, through: :categories


  def self.filter(params)
    scope = all
    if params[:name].present?
      scope = scope.where("name ILIKE ?", "%#{sanitize_sql_like(params[:name])}%")
    end
    scope
  end
end
