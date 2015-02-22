class CreateSetlist < ActiveRecord::Migration
  def change
    create_table :setlists do |t|
      t.string :name, null: false
      t.timestamps
    end
    create_table :setlist_songs do |t|
      t.belongs_to :song, null: false
      t.belongs_to :setlist, null: false
      t.integer :position, null: false, default: 0
      t.timestamps
    end
  end
end
