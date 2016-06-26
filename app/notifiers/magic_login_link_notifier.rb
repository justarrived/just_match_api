# frozen_string_literal: true

class MagicLoginLinkNotifier < BaseNotifier
  def self.call(user:)
    UserTexter.
      magic_login_link_text(user: user).
      deliver_later

    UserMailer.
      magic_login_link_email(user: user).
      deliver_later
  end
end
