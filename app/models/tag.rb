# frozen_string_literal: true

class Tag < ApplicationRecord
  has_many :user_tags, dependent: :destroy
  has_many :users, through: :user_tags

  validates :name, presence: true

  def self.to_form_array(include_blank: false)
    form_array = order(:name).pluck(:name, :id)
    return form_array unless include_blank

    [[I18n.t('admin.form.no_tag_chosen'), nil]] + form_array
  end

  def display_name
    "##{id} #{name}"
  end
end

# == Schema Information
#
# Table name: tags
#
#  id         :integer          not null, primary key
#  color      :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
