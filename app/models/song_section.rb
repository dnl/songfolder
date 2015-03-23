class SongSection

  LABELS = %w(verse chorus prechorus bridge intro introduction coda outro)

  attr_reader :label, :text

  def initialize(raw, song)
    @raw = raw
    @song = song
    @label, @text = split_label
  end

  def lines
    @lines ||= @text.lines.map { |line|
      ChordLine.valid?(line) ? ChordLine.new(line, @song) : LyricLine.new(line, @song)
    }
  end

  def chords
    lines.select{|l| l.is_a?(ChordLine) }.map(&:chords)
  end

  def normalised_label
    return nil unless label.present?
    label.downcase.gsub(/[^a-z]/, '').dasherize
  end

  def repeated?
    label.try(:match, /[2-9]/)
  end

private

  def split_label
    first_line = @raw.lines.first
    if first_line.match /^\s*(?:#{LABELS.join('|')})(?:\s?\d*)[:.]?\s*$/i
      return first_line.strip, @raw.lines.drop(1).join('')
    else
      [nil, @raw]
    end
  end

end