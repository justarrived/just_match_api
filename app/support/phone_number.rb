# frozen_string_literal: true

class PhoneNumber
  def self.normalize(phone_number)
    # GlobalPhone returns nil if the number is invalid
    GlobalPhone.normalize(phone_number, :se) || phone_number
  end

  def self.valid?(phone_number)
    number = GlobalPhone.parse(phone_number, :se)
    # GlobalPhone#valid? sometimes returns nil
    !!(number && number.valid?)
  end

  def self.swedish_number?(phone_number)
    number = GlobalPhone.parse(phone_number, :se)
    number && number.territory.name == 'SE'
  end
end
