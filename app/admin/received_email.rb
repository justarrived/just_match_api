# frozen_string_literal: true
ActiveAdmin.register ReceivedEmail do
  menu parent: 'Misc', priority: 5

  index do
    column :from_address
    column :to_address
    column :subject
    column :created_at

    actions
  end

  show do
    attributes_table do
      row :from_address
      row :to_address
      row :created_at { |email| datetime_ago_in_words(email.created_at) }
      row :subject
      row :text_body { |email| simple_format(email.text_body) }
      row :html_body
    end
  end
end
