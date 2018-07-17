# frozen_string_literal: true

class ClaimUtalkCodeService
  NoUnClaimedUtalkCodeError = Class.new(StandardError)

  def self.call(user:)
    return user.utalk_code if user.utalk_code

    utalk_code = UtalkCode.first_unclaimed
    raise(NoUnClaimedUtalkCodeError) unless utalk_code

    utalk_code.tap do |utalk|
      utalk.user = user
      utalk.claimed_at = Time.zone.now
      utalk.save!
    end
  end
end
