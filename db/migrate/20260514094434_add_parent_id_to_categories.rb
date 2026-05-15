class AddParentIdToCategories < ActiveRecord::Migration[8.1]
  def change
    add_column :t_categories, :parent_id, :integer, null: false, default: 0
  end
end
