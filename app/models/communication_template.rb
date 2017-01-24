# frozen_string_literal: true
class CommunicationTemplate < ApplicationRecord
  belongs_to :language

  validates :language, presence: true
  validates :subject, presence: true
  validates :body, presence: true
  validates :language, uniqueness: { scope: :category }
  validates :category, uniqueness: { scope: :language }

  include Translatable
  translates :subject, :body

  def self.to_form_array(include_blank: false)
    form_array = order(:category).pluck(:category, :id)
    return form_array unless include_blank

    [[I18n.t('admin.form.no_template_chosen'), nil]] + form_array
  end

  def display_name
    "##{id} #{category}"
  end
end

# == Schema Information
#
# Table name: communication_templates
#
#  id          :integer          not null, primary key
#  language_id :integer
#  category    :string
#  subject     :string
#  body        :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_communication_templates_on_language_id  (language_id)
#
# Foreign Keys
#
#  fk_rails_53f2d7081e  (language_id => languages.id)
#
