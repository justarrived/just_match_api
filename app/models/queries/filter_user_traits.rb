# frozen_string_literal: true
module Queries
  class FilterUserTraits
    def self.call(filter:, scope: User)
      skill_filters = filter.skill_filters
      language_filters = filter.language_filters
      interest_filters = filter.interest_filters
      scope = scope.joins(by_skill_filters_sql(skill_filters)) unless skill_filters.empty?
      scope = scope.joins(by_language_filters_sql(language_filters)) unless language_filters.empty? # rubocop:disable Metrics/LineLength
      scope = scope.joins(by_interest_filters_sql(interest_filters)) unless interest_filters.empty? # rubocop:disable Metrics/LineLength
      scope.distinct
    end

    def self.by_skill_filters_sql(skill_filters)
      skill_filters.each_with_index.map do |skill_filter, index|
        skill_id = skill_filter.skill_id
        proficiency = skill_filter.proficiency
        proficiency_by_admin = skill_filter.proficiency_by_admin

        as_table_name = "user_skills#{index}"
        prof_sql = trait_sql(as_table_name, proficiency, proficiency_by_admin)
        "INNER JOIN user_skills AS #{as_table_name} ON #{as_table_name}.user_id = users.id AND (#{as_table_name}.skill_id = #{skill_id} AND (#{prof_sql}))" # rubocop:disable Metrics/LineLength
      end.join(' ')
    end

    def self.by_language_filters_sql(language_filters)
      language_filters.each_with_index.map do |language_filter, index|
        language_id = language_filter.language_id
        proficiency = language_filter.proficiency
        proficiency_by_admin = language_filter.proficiency_by_admin

        as_table_name = "user_languages#{index}"
        prof_sql = trait_sql(as_table_name, proficiency, proficiency_by_admin)
        "INNER JOIN user_languages AS #{as_table_name} ON #{as_table_name}.user_id = users.id AND (#{as_table_name}.language_id = #{language_id} AND (#{prof_sql}))" # rubocop:disable Metrics/LineLength
      end.join(' ')
    end

    def self.by_interest_filters_sql(interest_filters)
      interest_filters.each_with_index.map do |interest_filter, index|
        interest_id = interest_filter.interest_id
        level = interest_filter.level
        level_by_admin = interest_filter.level_by_admin

        as_table_name = "user_interests#{index}"
        level_sql = trait_sql(as_table_name, level, level_by_admin, value_name: 'level')
        "INNER JOIN user_interests AS #{as_table_name} ON #{as_table_name}.user_id = users.id AND (#{as_table_name}.interest_id = #{interest_id} AND (#{level_sql}))" # rubocop:disable Metrics/LineLength
      end.join(' ')
    end

    def self.trait_sql(table, value, value_by_admin, value_name: 'proficiency')
      return 'true' if value.nil? && value_by_admin.nil?

      trait_sql_parts = []
      trait_sql_parts << "#{table}.#{value_name}_by_admin >= #{value_by_admin}" if value_by_admin # rubocop:disable Metrics/LineLength
      trait_sql_parts << "#{table}.#{value_name} >= #{value}" if value
      trait_sql_parts.join(' OR ')
    end
  end
end
