module Queries
  class SkillMatcher
    def initialize(scope, match_against_record)
      @scope = scope
      @record = match_against_record
      @table_name = @scope.table_name
    end

    def perform(strict_match: false)
      skills = @record.skills

      records = base_query(skills)
      if strict_match
        records = records.having('count(skills.id) = ?', skills.length)
      end
      records
    end

    private

    def base_query(skills)
      select_statement = [
        "#{@table_name}.*",
        "count(skills.id) as skill_count"
      ].join(',')

      @scope.joins(:skills)
        .where(skills: { id: skills })
        .select(select_statement)
        .group("#{@table_name}.id")
        .order('skill_count DESC')
    end
  end
end
