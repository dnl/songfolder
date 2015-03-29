class SetlistSong < ActiveRecord::Base
  belongs_to :song
  belongs_to :setlist

  default_scope { order(:position) }

  before_save :set_key

  def set_key
    self.key = song.key if read_attribute(:key).nil?
    true
  end

  def key
    return song.key if read_attribute(:key).blank?
    return read_attribute(:key)
  end
end