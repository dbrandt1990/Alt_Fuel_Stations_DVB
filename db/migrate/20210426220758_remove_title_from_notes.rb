class RemoveTitleFromNotes < ActiveRecord::Migration[6.1]
  def change
    remove_column :notes, :title
  end
end
