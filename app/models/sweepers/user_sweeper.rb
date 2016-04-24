# frozen_string_literal: true
module Sweepers
  class UserSweeper
    def self.create_frilans_finans(scope = User)
      scope.where(frilans_finans_id: nil).find_each(batch_size: 1000) do |user|
        attributes = {
          email: user.email,
          street: user.street,
          city: nil,
          country: user.country_name,
          cellphone: user.phone,
          first_name: user.first_name,
          last_name: user.last_name,
          social_security_nr: user.ssn
        }
        ff_user = FrilansFinansApi::User.create(attributes: attributes)
        ff_id = ff_user.resource.id

        next if ff_id.nil?

        user.frilans_finans_id = ff_id.to_i
        user.save!
      end
    end
  end
end
