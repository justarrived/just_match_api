# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Tag, type: :model do
  describe '#display_name' do
    it 'returns correct display name' do
      id = 7373
      tag = FactoryGirl.build(:tag, id: id)

      expect(tag.display_name).to eq("##{id} #{tag.name}")
    end
  end

  describe '#form_array' do
    context 'with include blank false' do
      it 'returns empty array if no tags' do
        tag_array = described_class.to_form_array(include_blank: false)
        expect(tag_array).to eq([])
      end

      it 'returns tag array' do
        tag = FactoryGirl.create(:tag)
        tag_array = described_class.to_form_array(include_blank: false)
        expect(tag_array).to eq([[tag.name, tag.id]])
      end
    end

    context 'with include blank' do
      let(:label) { I18n.t('admin.form.no_tag_chosen') }

      it 'returns empty array if no tags' do
        tag_array = described_class.to_form_array(include_blank: true)
        expect(tag_array).to eq([[label, nil]])
      end

      it 'returns tag array' do
        tag = FactoryGirl.create(:tag)
        tag_array = described_class.to_form_array(include_blank: true)
        expect(tag_array).to eq([[label, nil], [tag.name, tag.id]])
      end
    end
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
