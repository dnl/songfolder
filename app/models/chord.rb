class Chord

  REGEXP = / (?<chord>
             (?<root>[A-G][#b]?)
             (?<suffix>m|min|M|maj|sus|dim|add|madd)?
             (?<add>\d{1,2})?
        (?:\/(?<bass>[A-G][#+b]?))?
             )/x

  CIRCLE = {
    major: [0,5,7], #1 4 5 of chromatic scale
    minor: [2,4,9], #2,3,6 of chromatic scale
    diminished: [11]
  }
  SCALE_IN_CHROMATIC_SCALE = CIRCLE.values.flatten.sort
  ROOT = %w(A A# B C C# D D# E F F# G G#)
  ROOTROOT = ROOT + ROOT
  FLAT_ROOTS = %w(Db C# Ab G# Eb D# Bb A# F)

  attr_reader :root, :bass, :suffix, :add, :position

  def initialize(raw, song)
    @raw = raw
    @song = song
    if raw.is_a?(MatchData)
      from_match_data(raw)
    else
      from_match_data(raw.match(REGEXP))
    end
  end

  def roots
    CIRCLE[voice].try(:map) do |offset|
      ROOTROOT[ROOT.index(root enharmonic: :sharp) + 12 - offset]
    end || []
  end

  def voice
    return :major if major?
    return :minor if minor?
    return :diminished if diminished?
  end

  def major?
    return true if suffix.blank?
    return true if %w(M maj sus add).include? suffix
  end

  def minor?
    return true if suffix.blank? && add.to_i == 5
    return true if %w(min m madd).include? suffix
  end

  def diminished?
    return suffix == 'dim'
  end

  def chord(options = options_from_song)
    "#{chord_without_bass(options)}#{bass(options)}"
  end

  def chord_without_bass(options = options_from_song)
    "#{root(options)}#{suffix}#{add}"
  end

  def bass(options = options_from_song)
    "/#{Chord.process(@bass, options)}" if bass?
  end

  def root(options = options_from_song)
    Chord.process(@root, options)
  end

  def bass?
    @bass.present?
  end

  def inspect
    [chord({}), position]
  end

  def to_s
    chord({})
  end


private

  def options_from_song
    {root: @song.key, transpose: @song.in_key}
  end

  def from_match_data(data)
    @root = data[:root]
    @bass = data[:bass]
    @suffix = data[:suffix]
    @add = data[:add]
    @position = data.offset(:root).first
  end

  def self.process(key, options={})
    return sharp_enharmonic(key) if options[:enharmonic] == :sharp
    return  flat_enharmonic(key) if options[:enharmonic] == :flat
    return numeric(key, options[:root]) if options[:display] == :numeric
    return transpose(key, options[:transpose] || 0, options[:root]) if options[:root]
    return key
  end

  def self.transpose(key, offset, root)
    offset = Chord.normalise_transposition_offset(offset, root)
    position = Chord.chromatic_scale_from(root).index(key)
    new_root = Chord.chromatic_scale_from(root)[offset]
    new_key = Chord.chromatic_scale_from(new_root)[position]
    enharmonic(new_key, new_root)
  end

  def self.numeric(key, root)
    Chord.chromatic_scale_from(root).values_at(*SCALE_IN_CHROMATIC_SCALE).index(key) + 1
  end

  def self.enharmonic(key, root)
    if FLAT_ROOTS.include?(root)
      flat_enharmonic(key)
    else
      sharp_enharmonic(key)
    end
  end

  def self.sharp_enharmonic(key)
    return key unless key.include?("b")
    key.first.tr('ABCDEFG','GABCDEF') + '#'
  end

  def self.flat_enharmonic(key)
    return key unless key.include?("#")
    key.first.tr('ABCDEFG','BCDEFGA') + 'b'
  end

  def self.normalise_transposition_offset(offset, root)
    if offset.to_i.to_s == offset.to_s
      return offset.to_i + 12 if offset.to_i < 0
      offset.to_i
    else
      Chord.chromatic_scale_from(root).index(Chord.sharp_enharmonic(offset))
    end
  end

  def self.chromatic_scale_from(root)
    ROOTROOT.drop(ROOT.index(Chord.sharp_enharmonic(root))).take(12)
  end

end