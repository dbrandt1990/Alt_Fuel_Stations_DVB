class AddDefaultValueToElecInUsers < ActiveRecord::Migration[6.1]
  def change
    change_column_default :users, :ELEC, from: nil, to: true
  end
end
