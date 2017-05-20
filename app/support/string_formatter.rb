# frozen_string_literal: true

require 'markdowner'

class StringFormatter
  def to_html(string)
    return if string.blank?

    Markdowner.to_html(string)
  end

  def force_utf8(string)
    string&.encode('UTF-8', invalid: :replace)
  end
end
