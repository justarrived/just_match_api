# frozen_string_literal: true

class Interest < ApplicationRecord
  has_many :user_interests, dependent: :destroy
  has_many :users, through: :user_interests

  belongs_to :language, optional: true

  scope :order_by_name, (lambda { |direction: :asc|
    dir = direction.to_s == 'desc' ? 'DESC' : 'ASC'
    order("interest_translations.name #{dir}")
  })
  scope :visible, (-> { where(internal: false) })

  include Translatable
  translates :name

  def self.to_form_array(include_blank: false)
    form_array = with_translations.
                 order('interest_translations.name').
                 map { |interest| [interest.name, interest.id] }

    return form_array unless include_blank

    [[I18n.t('admin.form.no_interest_chosen'), nil]] + form_array
  end

  def display_name
    "##{id} #{name}"
  end
end

# == Schema Information
#
# Table name: interests
#
#  id          :integer          not null, primary key
#  name        :string
#  language_id :integer
#  internal    :boolean          default(FALSE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_interests_on_language_id  (language_id)
#
# Foreign Keys
#
#  fk_rails_...  (language_id => languages.id)
#
