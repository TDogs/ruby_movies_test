class CreateCategoriesAttributes < ActiveRecord::Migration[8.1]
  def change
    create_table :t_categories_attributes do |t|
      t.integer :category_id, null: false, index: true
      t.integer :attribute_id, null: false, index: true

      t.timestamps
    end
    add_foreign_key :t_categories_attributes, :t_categories, column: :category_id  # 本表中 category_id 关联 t_categories 表的 id
    add_foreign_key :t_categories_attributes, :t_attributes, column: :attribute_id  # 本表中 attribute_id 关联 t_attributes 表的 id
  end
end
