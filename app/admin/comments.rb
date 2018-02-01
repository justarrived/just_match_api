# frozen_string_literal: true

ActiveAdmin.register Comment do
  menu parent: 'Misc'

  filter :commentable_type
  filter :language
  filter :body
  filter :created_at
  filter :hidden

  index do
    selectable_column

    column :id
    column :commentable
    column I18n.t('admin.comment.commentable_type_header'), :commentable_type
    column :body { |comment| simple_format(comment.body) }
    column :created_at

    actions
  end
end
