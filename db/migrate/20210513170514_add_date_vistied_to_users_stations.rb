class AddDateVistiedToUsersStations < ActiveRecord::Migration[6.1]
  def change
    add_column :users_stations, :date_visited, :string
  end
end
