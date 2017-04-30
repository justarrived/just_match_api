# frozen_string_literal: true
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  scope :recent, ->(count) { order(created_at: :desc).limit(count) }
  scope :between, lambda { |field, from, to|
    where("#{field} >= ? AND #{field} <= ?", from, to)
  }
  scope :after, ->(field, datetime) { where("#{field} > ?", datetime) }
  scope :before, ->(field, datetime) { where("#{field} < ?", datetime) }

  def self.belongs_to_models
    reflections.map do |_, ba|
      next unless ba.macro == :belongs_to
      {
        model_klass: ba.klass,
        relation_name: ba.name
      }
    end.compact
  end

  def human_model_name
    self.class.model_name.human
  end

  # ActiveAdmin display name
  def display_name
    "##{id || 'unsaved'} " + human_model_name
  end
end
