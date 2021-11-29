class RemoveOutletTypesFromUsers < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :NEMA1450
    remove_column :users, :NEMA515
    remove_column :users, :NEMA520
    remove_column :users, :J1772
    remove_column :users, :J1772combo
    remove_column :users, :CHADEMO
    remove_column :users, :Tesla
  end
end
