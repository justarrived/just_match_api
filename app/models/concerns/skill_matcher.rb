module SkillMatcher
  def self.included(receiver)
    receiver.class_eval do
      def self.matches_resource(base_record, distance: 20)
        name = if base_record.is_a?(User)
                 'job_skills'
               elsif base_record.is_a?(Job)
                'user_skills'
               end

        resource_skills = base_record.skills.pluck(:id)
        matching_records = []

        # TODO: The below causes N+1 SQL
        within(lat: base_record.latitude, long: base_record.longitude, distance: distance)
          .joins(name.to_sym)
          .where("#{name}.skill_id IN (?)", resource_skills)
          .distinct
          .each do |record|
            if ArrayUtils.all_match?(record.skills.pluck(:id), resource_skills)
              matching_records << record
            end
          end

        matching_records
      end
    end
  end
end
