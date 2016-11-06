# frozen_string_literal: true
class CommentTranslation < ApplicationRecord
  belongs_to :comment

  include TranslationModel
end

# == Schema Information
#
# Table name: comment_translations
#
#  id         :integer          not null, primary key
#  locale     :string
#  body       :text
#  comment_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_comment_translations_on_comment_id  (comment_id)
#
# Foreign Keys
#
#  fk_rails_7d8cab2ad8  (comment_id => comments.id)
#
