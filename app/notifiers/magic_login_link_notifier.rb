# frozen_string_literal: true

class MagicLoginLinkNotifier < BaseNotifier
  def self.call(user:)
    if user.phone?
      envelope = UserTexter.magic_login_link_text(user: user)
      dispatch(envelope)
    end

    envelope = UserMailer.magic_login_link_email(user: user)
    dispatch(envelope)
  end
end
