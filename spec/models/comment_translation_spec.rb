# frozen_string_literal: true
require 'rails_helper'

RSpec.describe CommentTranslation, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
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
