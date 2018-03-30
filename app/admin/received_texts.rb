# frozen_string_literal: true

ActiveAdmin.register ReceivedText do
  menu parent: 'Misc', priority: 4

  index do
    column :from_number
    column :to_number
    column :body
    column :created_at

    actions
  end

  show do
    attributes_table do
      row :from_number
      row :to_number
      row(:created_at) { |email| datetime_ago_in_words(email.created_at) }
      row(:body) { |email| simple_format(email.body) }
    end
  end
end
