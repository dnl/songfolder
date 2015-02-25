module SongsHelper

  CHORD_RE = /^[A-G][#b]? #root of chord
              (?:m|min|M|maj|sus|dim|add)? #type of chord
              \d{0,2}            #value of add sus 7th chord etc
              (?:\/[A-G][#b]?)?  #bass note
              $/x

  LABELS = %w(verse chorus prechorus bridge intro introduction coda outro)

  LABEL_RE = /^\s*(?:#{LABELS.join('|')})(?:\s?\d*)[:.]?\s*$/i

  def song_format(text)
    capture do
      split_paragraphs(text).each do |part|
        concat format_song_part(part)
      end
    end
  end

  def format_song_part(part)
    label = extract_part_label(part)
    content_tag :div, class: song_part_classes(label) do
      part.each_line.with_index do |line, index|
        concat content_tag(:div, line, class: line_classes(line, index))
      end
    end
  end

  def line_classes(line, index)
    classes = []
    classes << 'chords' if is_mostly_chords(line)
    classes << 'label' if index.zero? && line.match(LABEL_RE)
    classes.join(' ')
  end

  def is_mostly_chords(line)
    words = line.strip.split(/[\s-]+/)

    chords = words.count {|w| w.match(CHORD_RE) }
    words = words.length - chords
    return words.zero? || words < chords/2
  end

  def song_part_classes(label)
    classes = ['part']
    if label
      classes << label.downcase.gsub(/[^a-z]/, '').dasherize
      classes << 'part-repeated' if label.match /[23456789]/
    end
    classes.join(' ')
  end

  def split_paragraphs(text)
    text.to_s.gsub(/\r\n?/, "\n").split(/(?:[ \t]*\n){2,}/)
  end

  def extract_part_label(part)
    case part.lines.first
    when LABEL_RE
      part.lines.first
    end
  end
end
