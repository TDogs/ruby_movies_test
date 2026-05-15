class CreateGoodsAttributeValues < ActiveRecord::Migration[8.1]
  def change
    create_table :t_goods_attribute_values do |t|
      t.integer :goods_id, null: false, index: true
      t.integer :attribute_id, null: false, index: true
      t.string :value

      t.timestamps
    end

    add_foreign_key :t_goods_attribute_values, :t_goods, column: :goods_id  # 本表中 goods_id 关联 t_goods 表的 id
    add_foreign_key :t_goods_attribute_values, :t_attributes, column: :attribute_id  # 本表中 attribute_id 关联 t_attributes 表的 id
  end
end
