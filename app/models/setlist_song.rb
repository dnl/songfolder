class SetlistSong < ActiveRecord::Base
  belongs_to :song
  belongs_to :setlist

  default_scope { order(:position) }
end