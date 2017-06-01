# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Interest, type: :model do
  describe '#to_form_array' do
    context 'with include blank false' do
      it 'returns empty array if no interests' do
        interest_array = described_class.to_form_array(include_blank: false)
        expect(interest_array).to eq([])
      end

      it 'returns interest array' do
        interest = FactoryGirl.create(:interest_with_translation)
        interest_array = described_class.to_form_array(include_blank: false)
        expect(interest_array).to eq([[interest.name, interest.id]])
      end
    end

    context 'with include blank' do
      let(:label) { I18n.t('admin.form.no_interest_chosen') }

      it 'returns empty array if no interests' do
        interest_array = described_class.to_form_array(include_blank: true)
        expect(interest_array).to eq([[label, nil]])
      end

      it 'returns interest array' do
        interest = FactoryGirl.create(:interest_with_translation)
        interest_array = described_class.to_form_array(include_blank: true)
        expect(interest_array).to eq([[label, nil], [interest.name, interest.id]])
      end
    end
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
#  fk_rails_4b04e42f8f  (language_id => languages.id)
#
