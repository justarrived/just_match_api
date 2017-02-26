# frozen_string_literal: true
module Index
  class UserDocumentsIndex < BaseIndex
    ALLOWED_FILTERS = %i(category).freeze
    SORTABLE_FIELDS = %i(category created_at).freeze

    def user_documents(scope = UserDocument)
      @user_documents ||= prepare_records(scope.includes(:document))
    end
  end
end
