# frozen_string_literal: true
ActiveAdmin.register FrilansFinansApiLog do
  menu parent: 'Frilans Finans'

  scope :all, default: true
  scope :created
  scope :success
  scope :unproccessable_entity
  scope :server_error

  filter :status
  filter :verb
  filter :uri
  filter :params
  filter :response_body
  filter :created_at

  index do
    selectable_column

    column :id
    column :status
    column :verb
    column :uri
    column :created_at

    actions
  end

  show do
    attributes_table do
      row :id
      row :status
      row :status_name
      row :verb
      row :uri
      row :created_at { |log| datetime_ago_in_words(log.created_at) }
      row :params do |log|
        content_tag :pre, begin
          hash = JSON.parse(log.params)
          hash['body'] = JSON.parse(hash['body'])
          JSON.pretty_generate(hash)
        rescue JSON::ParserError => _e
          log.params
        end
      end
      row :response_body { |log| safe_pretty_print_json(log.response_body) }
    end
  end
end
