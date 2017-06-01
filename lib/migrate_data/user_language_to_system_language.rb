# frozen_string_literal: true

class UserLanguageToSystemLanguage
  def self.up
    User.all.find_each(batch_size: 500) do |user|
      user.system_language = user.language
      user.save!(validate: false)
    end
  end

  def self.down
    fail('Irreversible data migration')
  end
end
