
class CategoriesAttribute < ApplicationRecord
  self.table_name = "t_categories_attributes"

  # 分类
  belongs_to :category, foreign_key: :category_id, inverse_of: :categories_attributes

  # 属性 给attr简称
  belongs_to :attr,
    class_name: "Attribute",
    foreign_key: :attribute_id,
    inverse_of: :categories_attributes
end
