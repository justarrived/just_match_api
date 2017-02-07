# frozen_string_literal: true
class SetFilterUsersService
  def self.call(filter:)
    FilterUser.transaction do
      FilterUser.where(filter: filter).delete_all
      Queries::UserTraits.by_filter(filter).find_each do |user|
        FilterUser.create(user: user, filter: filter)
      end
    end
  end
end
