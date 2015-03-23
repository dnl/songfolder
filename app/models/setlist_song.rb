class SetlistSong < ActiveRecord::Base
  belongs_to :song
  belongs_to :setlist

  default_scope { order(:position) }

  before_save :set_key

  def set_key
    self.key = song.key if self.key.nil?
    true
  end
end