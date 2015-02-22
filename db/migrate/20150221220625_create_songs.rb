class CreateSongs < ActiveRecord::Migration
  def change
    create_table :songs do |t|
      t.string :title, null:false
      t.text :song, null:false
      t.string :youtube_link
      t.string :source
      t.string :artist
      t.timestamps null: false
    end
  end
end
