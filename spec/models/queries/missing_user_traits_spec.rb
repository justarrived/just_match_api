# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Queries::MissingUserTraits do
  describe '#attributes' do
    it 'with missing user attributes it returns a list of missing attribute names' do
      user = User.new
      expected = %w(ssn street zip city phone bank_account)
      result = described_class.attributes(user: user, attributes: expected)
      expect(result).to include(*expected)
    end

    it 'with *no* missing user attributes it returns an empty list' do
      user = FactoryGirl.build(:user, :bank_account)
      attributes = %w(ssn street zip city phone bank_account)
      expect(described_class.attributes(user: user, attributes: attributes)).to be_empty
    end
  end

  describe '#skills' do
    let(:user) { FactoryGirl.create(:user) }

    it 'with missing skills it returns a collection of those skills' do
      skill1 = FactoryGirl.create(:skill)
      skill2 = FactoryGirl.create(:skill)

      expected = [skill1, skill2]
      skills = described_class.skills(user: user, skills: expected)
      expect(skills).to eq(expected)
    end

    it 'with *no* missing skills it returns an empty list' do
      skill1 = FactoryGirl.create(:skill)
      skill2 = FactoryGirl.create(:skill)

      expected = [skill1, skill2]
      user.skills = expected

      skills = described_class.skills(user: user, skills: expected)
      expect(skills).to be_empty
    end
  end

  describe '#languages' do
    let(:user) { FactoryGirl.create(:user) }

    it 'with missing languages it returns a collection of those languages' do
      en = Language.find_or_create_by(lang_code: :en)
      sv = Language.find_or_create_by(lang_code: :sv)

      expected = [en, sv]
      languages = described_class.languages(user: user, languages: expected)
      expect(languages).to eq(expected)
    end

    it 'with *no* missing languages it returns an empty list' do
      en = Language.find_or_create_by(lang_code: :en)
      sv = Language.find_or_create_by(lang_code: :sv)

      expected = [en, sv]
      user.languages = expected

      languages = described_class.languages(user: user, languages: expected)
      expect(languages).to be_empty
    end
  end

  describe '#cv?' do
    let(:user) { FactoryGirl.create(:user) }

    it 'returns true if cv is missing' do
      expect(described_class.cv?(user: user)).to eq(true)
    end

    it 'retruns false if cv is present' do
      FactoryGirl.create(:user_document, user: user, category: :cv)
      expect(described_class.cv?(user: user)).to eq(false)
    end
  end
end
