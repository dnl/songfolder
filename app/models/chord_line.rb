class ChordLine

  attr_reader :text

  def initialize(raw, song)
    @text = raw
    @song = song
  end

  def chords
    text.to_enum(:scan, Chord::REGEXP).map{ Chord.new($~, @song) }.to_a
  end

  def chords_with_spaces
    offset = 0
    output = []
    chords.each do |chord|
      spaces = if offset.zero?
        0
      elsif chord.position > offset
        chord.position - offset
      else
        1
      end
      output << (' ' * spaces)
      offset += spaces
      output << chord
      offset += chord.chord.length
    end
    output
  end

  def self.valid? line
    words = line.strip.split(/[\s-]+/)

    chords = words.count {|w| w.match(Chord::REGEXP) }
    return false if chords.zero?
    words = words.length - chords
    return words.zero? || words < chords/2
  end

end