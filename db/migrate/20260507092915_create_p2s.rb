class CreateP2s < ActiveRecord::Migration[8.1]
  def change
    create_table :p2s do |t|
      t.string :name
      t.string :email

      t.timestamps
    end
  end
end
