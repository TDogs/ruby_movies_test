class AddIndexToP2sSex < ActiveRecord::Migration[8.1]
  def change
    add_index :p2s, :sex
  end
end
