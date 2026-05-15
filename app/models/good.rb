class Good < ApplicationRecord
  self.table_name = "t_goods"
  belongs_to :category # 取每个商品的主分类

  def self.filter(params)
    scope = all
    if params[:name].present?
      scope = scope.where("name ILIKE ?", "%#{sanitize_sql_like(params[:name])}%")
    end
    scope
  end
end
