class CreateAttributes < ActiveRecord::Migration[8.1]
  def change
    create_table :t_attributes do |t|
      t.string :name

      t.timestamps
    end
  end
end
