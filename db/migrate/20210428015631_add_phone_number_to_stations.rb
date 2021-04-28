class AddPhoneNumberToStations < ActiveRecord::Migration[6.1]
  def change
    add_column :stations, :phone, :string
  end
end
