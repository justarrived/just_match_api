# frozen_string_literal: true

class AnonymizeUserService
  def self.call(user, force: false)
    if !force && !user.anonymization_allowed?
      raise(ArgumentError, 'not allowed to anonymize user!')
    end

    user.anonymize_attributes
    user.save!
  end
end
