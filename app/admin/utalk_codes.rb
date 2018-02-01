# frozen_string_literal: true

ActiveAdmin.register UtalkCode do
  menu parent: 'Misc'

  permit_params do
    %i[
      code
      user_id
      claimed_at
    ]
  end

  controller do
    def scoped_collection
      super.includes(:user)
    end
  end
end
