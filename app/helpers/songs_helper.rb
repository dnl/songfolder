module SongsHelper

  def song_format(song)
    capture do
      song.sections.each do |section|
        concat format_song_part(song, section)
      end
    end
  end

  def format_song_part(song, section)
    content_tag :div, class: song_part_classes(section) do
      concat content_tag(:div, section.label, class: 'label')
      section.lines.each do |line|
        concat format_line(song, line)
      end
    end
  end

  def format_line(song, line)
    case line
    when ChordLine
      format_chord_line(song, line)
    else
      content_tag(:div, line.text)
    end
  end

  def format_chord_line(song, line)
    content_tag(:div, class: 'chords') do
      line.chords_with_spaces.each do |chord|
        if chord.is_a?(Chord)
          concat format_chord(song, chord)
        else
          concat chord
        end
      end
    end
  end

  def format_chord(song, chord)
    content_tag(:span, class: 'chord', data: {chord: chord.chord }) do
      concat chord.chord_without_bass
      concat content_tag(:span, "#{chord.bass}", class: 'bass') if chord.bass?
    end
  end

  def song_part_classes(section)
    ['part',
      section.normalised_label,
      ('part-repeated' if section.repeated?)
    ].compact.join(' ')
  end

end
