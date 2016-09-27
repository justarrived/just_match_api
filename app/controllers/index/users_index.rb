# frozen_string_literal: true
module Index
  class UsersIndex < BaseIndex
    FILTER_MATCH_TYPES = {
      first_name: :starts_with,
      last_name: :starts_with,
      email: :starts_with
    }.freeze
    ALLOWED_FILTERS = %i(id email first_name last_name).freeze
    SORTABLE_FIELDS = %i(created_at first_name last_name).freeze

    def users(scope = User)
      @users ||= begin
        scope_includes = %i(language languages company chats)

        prepare_records(scope.includes(*scope_includes))
      end
    end
  end
end
