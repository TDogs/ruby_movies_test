class CreateAdminPowersNews < ActiveRecord::Migration[8.1]
  def change
    create_table :admin_powers_new do |t|
      t.string :menu_id, null: false
      t.string :name
      t.integer :status

      t.timestamps
    end
  end
end
