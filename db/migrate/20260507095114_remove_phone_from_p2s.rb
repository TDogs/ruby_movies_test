class RemovePhoneFromP2s < ActiveRecord::Migration[8.1]
  def change
    remove_column :p2s, :phone, :string
  end
end
