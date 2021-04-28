class AddDefaultToPhoneInStations < ActiveRecord::Migration[6.1]
  def change
    change_column_default :stations, :phone, from: nil, to: "N/A"
  end
end
