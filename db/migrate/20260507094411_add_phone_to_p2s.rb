class AddPhoneToP2s < ActiveRecord::Migration[8.1]
  def change
    add_column :p2s, :phone, :string
  end
end
