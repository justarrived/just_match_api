module SkillMatchable
  def self.included(receiver)
    receiver.class_eval do
      def self.order_by_matching_skills(base_record, strict_match: false)
        query = Queries::SkillMatcher.new(self, base_record)
        query.perform(strict_match: strict_match)
      end
    end
  end
end
