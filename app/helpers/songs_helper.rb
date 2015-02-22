module SongsHelper

  KEYS = %w(A A# Bb B C C# Db D D# Eb E F F# Gb G G# Ab)
  CHORD_MODIFIERS =[%w(m min maj sus dim), 1..13]

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
        concat content_tag(:div, line, class: line_classes(line, index, !!label))
      end
    end
  end

  def line_classes(line, index, has_label)
    classes = []
    classes << 'chords' if has_label ? index.odd? : index.even?
    classes << 'label' if index.zero? && has_label
    classes.join(' ')
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
    when /\:$/
      part.lines.first
    end
  end
end
