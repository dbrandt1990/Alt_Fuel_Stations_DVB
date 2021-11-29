class CreateUsersStation < ActiveRecord::Migration[6.1]
  def change
    create_table :users_stations do |t|
      t.belongs_to :user
      t.belongs_to :station
      
      t.timestamps
    end
  end
end
