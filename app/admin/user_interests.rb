# frozen_string_literal: true

ActiveAdmin.register UserInterest do
  menu parent: 'Users'

  filter :interest, collection: -> { Interest.with_translations.order_by_name }
  filter :level
  filter :level_by_admin
  filter :updated_at
  filter :created_at

  index do
    selectable_column

    column :id
    column :name do |user_interests|
      interest = user_interests.interest

      link_to(
        interest.name,
        admin_users_path + AdminHelpers::Link.query(:user_interests_interest_id, interest.id) # rubocop:disable Metrics/LineLength
      )
    end
    column :level
    column :level_by_admin
    column :user
    column :created_at

    actions
  end

  permit_params do
    %i(user_id interest_id level level_by_admin)
  end

  controller do
    def scoped_collection
      super.includes(:user, interest: %i(translations language))
    end
  end
end
