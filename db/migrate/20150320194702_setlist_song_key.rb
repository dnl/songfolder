class SetlistSongKey < ActiveRecord::Migration
  def change
    add_column :setlist_songs, :key, :string, length: 2
  end
end
