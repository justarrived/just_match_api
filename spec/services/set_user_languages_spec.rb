# frozen_string_literal: true
require 'rails_helper'

RSpec.describe SetUserLanguagesService do
  describe '::call' do
    let(:user) { FactoryGirl.create(:user) }
    let(:language) { FactoryGirl.create(:language) }
    let(:proficiency) { 4 }
    let(:language_param) do
      [{ id: language.id, proficiency: proficiency }]
    end

    it 'set user languages' do
      expect(user.user_languages).to be_empty
      described_class.call(user: user, language_ids_param: language_param)
      expect(user.user_languages.first.proficiency).to eq(4)
      expect(user.user_languages.length).to eq(1)
    end
  end
end
