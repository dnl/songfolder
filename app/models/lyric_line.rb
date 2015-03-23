class LyricLine
  attr_reader :text

  def initialize(raw, song)
    @text = raw
    @song = song
  end
end