# frozen_string_literal: true
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.belongs_to_models
    reflections.map do |_, ba|
      next unless ba.macro == :belongs_to
      {
        model_klass: ba.klass,
        relation_name: ba.name
      }
    end.compact
  end
end
