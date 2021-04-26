class AddStateAndCityToStations < ActiveRecord::Migration[6.1]
  def change
    add_column :stations, :city, :string
    add_column :stations, :state, :string
  end
end
