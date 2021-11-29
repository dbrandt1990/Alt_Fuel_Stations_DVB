class RemoveUpdatesFromUsers < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :updates
  end
end
