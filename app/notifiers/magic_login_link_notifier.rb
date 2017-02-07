# frozen_string_literal: true
class MagicLoginLinkNotifier < BaseNotifier
  def self.call(user:)
    notify do
      UserTexter.magic_login_link_text(user: user) if user.phone?
    end

    notify do
      UserMailer.
        magic_login_link_email(user: user)
    end
  end
end
