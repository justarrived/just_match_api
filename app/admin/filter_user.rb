# frozen_string_literal: true
ActiveAdmin.register FilterUser do
  menu parent: 'Filters', priority: 2

  filter :filter, collection: -> { Filter.order(:name) }
  filter :created_at

  index do
    column :id
    column :name do |filter_user|
      filter = filter_user.filter
      link_to(filter.display_name, admin_filter_path(filter))
    end
    column :name do |filter_user|
      user = filter_user.user
      link_to(user.display_name, admin_user_path(user))
    end
    column :created_at

    actions
  end

  controller do
    def scoped_collection
      super.includes(:filter, :user)
    end
  end
end
