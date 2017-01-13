# frozen_string_literal: true
class EmailSuggestion
  def self.call(email)
    suggestion = Mailcheck.new.suggest(email)
    return suggestion if suggestion
    {}
  end
end
