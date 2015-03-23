class Song < ActiveRecord::Base
  has_many :setlist_songs
  has_many :setlists, through: :setlist_songs

  default_scope { order(:title) }

  attr_accessor :in_key

  KEY_RE = /\A[A-Ga-g][#b]?m?\z/

  def sections
    @sections ||= song.split(/(?:[ \t]*\n){2,}/).map { |t| SongSection.new(t, self) }
  end

  def chords
    sections.map(&:chords).flatten
  end

  def key
    return @key if @key.present?
    keys = chords.map(&:roots)
    @key = keys.flatten.uniq.sort_by {|k| keys.count {|kk| !kk.include?(k)} }.first
  end

  def song
    read_attribute(:song).to_s.gsub(/\r\n?/, "\n")
  end
end
