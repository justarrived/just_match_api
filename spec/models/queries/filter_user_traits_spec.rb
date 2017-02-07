# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Queries::FilterUserTraits do
  describe '::call' do
    it 'returns matching users' do
      filter = FactoryGirl.create(:filter)
      user1 = FactoryGirl.create(:user)
      user2 = FactoryGirl.create(:user)
      user3 = FactoryGirl.create(:user)
      user4 = FactoryGirl.create(:user)
      skill1 = FactoryGirl.create(:skill)
      skill2 = FactoryGirl.create(:skill)
      language = FactoryGirl.create(:language)
      interest1 = FactoryGirl.create(:interest, id: 111_111)
      interest2 = FactoryGirl.create(:interest, id: 111_112)

      # rubocop:disable Metrics/LineLength
      # user1
      FactoryGirl.create(:user_skill, proficiency: 3, proficiency_by_admin: 2, user: user1, skill: skill1)
      FactoryGirl.create(:user_skill, proficiency: 4, proficiency_by_admin: 3, user: user1, skill: skill2)
      FactoryGirl.create(:user_language, proficiency: 3, proficiency_by_admin: 4, user: user1, language: language)
      FactoryGirl.create(:user_interest, level: 3, level_by_admin: 4, user: user1, interest: interest1)
      FactoryGirl.create(:user_interest, level: 3, level_by_admin: 4, user: user1, interest: interest2)
      # user2
      FactoryGirl.create(:user_skill, proficiency: 3, proficiency_by_admin: 2, user: user2, skill: skill1)
      FactoryGirl.create(:user_skill, proficiency: 4, proficiency_by_admin: 3, user: user2, skill: skill2)
      # user3
      FactoryGirl.create(:user_skill, proficiency: 4, proficiency_by_admin: 3, user: user3, skill: skill2)
      # user4
      FactoryGirl.create(:user_skill, proficiency: 3, proficiency_by_admin: 2, user: user4, skill: skill1)
      FactoryGirl.create(:user_skill, proficiency: 4, proficiency_by_admin: 3, user: user4, skill: skill2)
      FactoryGirl.create(:user_language, proficiency: 3, proficiency_by_admin: 4, user: user4, language: language)
      FactoryGirl.create(:user_interest, level: 3, level_by_admin: 4, user: user4, interest: interest1)
      FactoryGirl.create(:user_interest, level: 1, level_by_admin: 1, user: user4, interest: interest2)

      # Create skill filters
      FactoryGirl.create(:skill_filter, skill: skill1, filter: filter, proficiency: 2, proficiency_by_admin: 2)
      FactoryGirl.create(:skill_filter, skill: skill2, filter: filter, proficiency: 3, proficiency_by_admin: 3)

      result1 = described_class.call(filter: filter)
      expect(result1).to include(user1)
      expect(result1).to include(user2)
      expect(result1).to include(user4)
      expect(result1).not_to include(user3)

      # Create language filter
      FactoryGirl.create(:language_filter, language: language, filter: filter, proficiency: 3, proficiency_by_admin: 3)

      result2 = described_class.call(filter: filter)
      expect(result2).to include(user1)
      expect(result2).not_to include(user2)
      expect(result2).not_to include(user3)
      expect(result2).to include(user4)

      # Create language filters
      FactoryGirl.create(:interest_filter, interest: interest1, filter: filter, level: 3, level_by_admin: 3)
      FactoryGirl.create(:interest_filter, interest: interest2, filter: filter, level: 2, level_by_admin: 3)

      result3 = described_class.call(filter: filter)
      expect(result3).to include(user1)
      expect(result3).not_to include(user2)
      expect(result3).not_to include(user3)
      expect(result3).not_to include(user4)
      # rubocop:enable Metrics/LineLength
    end
  end

  describe '::by_skill_filters_sql' do
    # rubocop:disable Metrics/LineLength
    it 'returns the correct SQL string' do
      skill1 = FactoryGirl.build(:skill, id: 1018)
      skill2 = FactoryGirl.build(:skill, id: 1019)
      skill_filters = [
        FactoryGirl.build(:skill_filter, skill: skill1, id: 1, proficiency: 1, proficiency_by_admin: 1),
        FactoryGirl.build(:skill_filter, skill: skill2, id: 2, proficiency: 2, proficiency_by_admin: 2)
      ]
      sql = described_class.by_skill_filters_sql(skill_filters)
      expected = "INNER JOIN user_skills AS user_skills0 ON user_skills0.user_id = users.id AND (user_skills0.skill_id = #{skill1.id} AND (user_skills0.proficiency_by_admin >= 1 OR user_skills0.proficiency >= 1)) INNER JOIN user_skills AS user_skills1 ON user_skills1.user_id = users.id AND (user_skills1.skill_id = #{skill2.id} AND (user_skills1.proficiency_by_admin >= 2 OR user_skills1.proficiency >= 2))" # rubocop:disable Metrics/LineLength
      expect(sql).to eq(expected)
    end
    # rubocop:enable Metrics/LineLength
  end

  describe '::by_language_filters_sql' do
    # rubocop:disable Metrics/LineLength
    it 'returns the correct SQL string' do
      lang1 = FactoryGirl.build(:language, id: 1033)
      lang2 = FactoryGirl.build(:language, id: 1034)
      language_filters = [
        FactoryGirl.build(:language_filter, language: lang1, id: 1, proficiency: 1, proficiency_by_admin: 1),
        FactoryGirl.build(:language_filter, language: lang2, id: 2, proficiency: 2, proficiency_by_admin: 2)
      ]
      sql = described_class.by_language_filters_sql(language_filters)
      expected = "INNER JOIN user_languages AS user_languages0 ON user_languages0.user_id = users.id AND (user_languages0.language_id = #{lang1.id} AND (user_languages0.proficiency_by_admin >= 1 OR user_languages0.proficiency >= 1)) INNER JOIN user_languages AS user_languages1 ON user_languages1.user_id = users.id AND (user_languages1.language_id = #{lang2.id} AND (user_languages1.proficiency_by_admin >= 2 OR user_languages1.proficiency >= 2))" # rubocop:disable Metrics/LineLength
      expect(sql).to eq(expected)
    end
    # rubocop:enable Metrics/LineLength
  end

  describe '::by_interest_filters_sql' do
    # rubocop:disable Metrics/LineLength
    it 'returns the correct SQL string' do
      interest1 = FactoryGirl.build(:interest, id: 1057)
      interest2 = FactoryGirl.build(:interest, id: 1058)
      interest_filters = [
        FactoryGirl.build(:interest_filter, interest: interest1, id: 1, level: 1, level_by_admin: 1),
        FactoryGirl.build(:interest_filter, interest: interest2, id: 2, level: 2, level_by_admin: 2)
      ]
      sql = described_class.by_interest_filters_sql(interest_filters)
      expected = "INNER JOIN user_interests AS user_interests0 ON user_interests0.user_id = users.id AND (user_interests0.interest_id = #{interest1.id} AND (user_interests0.level_by_admin >= 1 OR user_interests0.level >= 1)) INNER JOIN user_interests AS user_interests1 ON user_interests1.user_id = users.id AND (user_interests1.interest_id = #{interest2.id} AND (user_interests1.level_by_admin >= 2 OR user_interests1.level >= 2))" # rubocop:disable Metrics/LineLength
      expect(sql).to eq(expected)
    end
    # rubocop:enable Metrics/LineLength
  end

  describe '::trait_sql' do
    # rubocop:disable Metrics/LineLength
    it 'returns correct sql for nil value & nil value_by_admin' do
      expect(described_class.trait_sql('test_table_name', nil, nil)).to eq('true')
    end

    it 'returns correct sql for only value' do
      expect(described_class.trait_sql('test_table_name', 2, nil)).to eq('test_table_name.proficiency >= 2')
    end

    it 'returns correct sql for only value_by_admin' do
      expect(described_class.trait_sql('test_table_name', nil, 3)).to eq('test_table_name.proficiency_by_admin >= 3')
    end

    it 'returns correct sql for only value & value_by_admin' do
      expect(described_class.trait_sql('test_table_name', 2, 3)).to eq('test_table_name.proficiency_by_admin >= 3 OR test_table_name.proficiency >= 2')
    end

    it 'returns value name as "proficiency" & "proficiency_by_admin" by default' do
      expect(described_class.trait_sql('test_table_name', 2, 3)).to include('proficiency_by_admin')
      expect(described_class.trait_sql('test_table_name', 2, 3)).to include('proficiency')
    end

    it 'returns value name as passed' do
      expect(described_class.trait_sql('test_table_name', 2, 3, value_name: 'watman')).to include('watman_by_admin')
      expect(described_class.trait_sql('test_table_name', 2, 3, value_name: 'watman')).to include('watman')
    end
    # rubocop:enable Metrics/LineLength
  end
end
