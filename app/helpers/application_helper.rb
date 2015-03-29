module ApplicationHelper
  def key_options(key)
    options_for_select(
      ['A','Bb','B','C','Db','D','Eb','E','F',['F+', 'F#'], 'G', 'Ab'],
      key.try(:gsub, /#/, '+')
    )
  end
end
