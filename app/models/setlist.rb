class Setlist < ActiveRecord::Base
  has_many :setlist_songs, dependent: :delete_all, autosave: true
  has_many :songs, through: :setlist_songs

  accepts_nested_attributes_for :setlist_songs

  def song_ids=(ids)
    old_song_ids = []
    self.setlist_songs.each do |old_song|
      if ids.include?(old_song.song_id)
        ids.delete old_song.song_id
      else
        old_song.mark_for_destruction
      end
    end
    position = setlist_songs.last.try(:position) || -1
    ids.each do |id|
      self.setlist_songs << SetlistSong.new(song_id:id, setlist: self, position: position + 1)
    end
  end

  def setlist_song_at_index(index)
    setlist_songs.offset(index).first
  end

  def prev_song(index)
    return nil if index.to_i.zero?
    setlist_song_at_index(index.to_i-1).try(:song)
  end

  def next_song(index)
    setlist_song_at_index(index.to_i+1).try(:song)
  end

end