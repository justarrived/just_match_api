# frozen_string_literal: true
module MailerHelper
  def phone_to(number)
    link_to(number, "tel:#{number}")
  end

  def address_to(address)
    link_to(address, GoogleMapsUrl.build(address))
  end
end
