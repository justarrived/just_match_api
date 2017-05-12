# frozen_string_literal: true
module MailerHelper
  def phone_to(number)
    link_to(number, "tel:#{number}")
  end

  def address_to(address)
    link_to(address, GoogleMapsUrl.build(address))
  end

  def frontend_mail_url(name, **args)
    args[:utm_medium] = UTM_MAILER_MEDIUM
    FrontendRouter.draw(name, **args)
  end
end
