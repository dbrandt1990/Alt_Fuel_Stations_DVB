class CapitalizeJ1772comboInStations < ActiveRecord::Migration[6.1]
  def change
    rename_column :stations, :J1772combo, :J1772COMBO
  end
end
