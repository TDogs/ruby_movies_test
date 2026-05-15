class CreateGoods < ActiveRecord::Migration[8.1]
  def change
    create_table :t_goods do |t|
      t.string :name
      t.integer :category_id, null: false, index: true

      t.timestamps
    end
    add_foreign_key :t_goods, :t_categories, column: :category_id
  end
end
