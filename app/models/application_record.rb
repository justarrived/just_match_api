# frozen_string_literal: true
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.belongs_to_models
    reflections.collect do |_, ba|
      if ba.macro == :belongs_to
        {
          model_klass: ba.klass,
          relation_name: ba.name
        }
      end
    end.compact
  end
end
