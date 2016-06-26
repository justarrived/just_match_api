# frozen_string_literal: true
class UserTexter < ApplicationTexter
  def self.magic_login_link_text(user:)
    @magic_login_url = FrontendRouter.draw(:magic_login_link, token: user.one_time_token)

    text(to: user.phone, template: 'user_texter/magic_login_link_text')
  end
end
