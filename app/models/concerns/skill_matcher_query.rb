module SkillMatcherQuery
  def self.included(receiver)
    receiver.class_eval do
      def self._order_by_matching(skills)
        select_statement = [
          "#{table_name}.*",
          "count(skills.id) as skill_count"
        ].join(',')

        joins(:skills)
          .where(skills: { id: skills })
          .select(select_statement)
          .group("#{table_name}.id")
          .order('skill_count DESC')
      end

      def self.order_by_matching_skills(base_record, distance: 20, strict_match: true)
        skills = base_record.skills

        lat = base_record.latitude
        long = base_record.longitude

        records = within(lat: lat, long: long, distance: distance)
          ._order_by_matching(skills)
        if strict_match
          records = records.having('count(skills.id) = ?', skills.length)
        end
        records
      end
    end
  end
end
