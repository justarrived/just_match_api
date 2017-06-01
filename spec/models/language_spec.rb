# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Language, type: :model do
  describe '#name_for' do
    it 'returns name for locale' do
      lang = FactoryGirl.build(:language, sv_name: 'Engelska')
      expect(lang.name_for(:sv)).to eq('Engelska')
    end

    it 'returns English fallback name for locale if name does not exist in that locale' do
      lang = FactoryGirl.build(:language, sv_name: '', en_name: 'English')
      expect(lang.name_for(:sv)).to eq('English')
    end

    it 'returns locale fallback name for locale if name does not exist in that locale' do
      lang = FactoryGirl.build(:language, sv_name: nil, en_name: nil, local_name: 'loc')
      expect(lang.name_for(:sv)).to eq('loc')
    end
  end
end

# == Schema Information
#
# Table name: languages
#
#  id                  :integer          not null, primary key
#  lang_code           :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  en_name             :string
#  direction           :string
#  local_name          :string
#  system_language     :boolean          default(FALSE)
#  sv_name             :string
#  ar_name             :string
#  fa_name             :string
#  fa_af_name          :string
#  ku_name             :string
#  ti_name             :string
#  ps_name             :string
#  machine_translation :boolean          default(FALSE)
#
# Indexes
#
#  index_languages_on_lang_code  (lang_code) UNIQUE
#
