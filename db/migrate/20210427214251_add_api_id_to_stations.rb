class AddApiIdToStations < ActiveRecord::Migration[6.1]
  def change
    add_column :stations, :api_id, :integer
  end
end
