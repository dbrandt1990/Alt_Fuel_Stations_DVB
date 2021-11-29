class CreateNotes < ActiveRecord::Migration[6.1]
  def change
    create_table :notes do |t|
      t.string :title
      t.text :content
      t.belongs_to :user
      t.belongs_to :station
      t.boolean :admin, default: false

      t.timestamps
    end
  end
end
