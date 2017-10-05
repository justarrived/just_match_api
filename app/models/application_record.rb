# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  scope :recent, (->(count) { order(created_at: :desc).limit(count) })
  scope :between, (lambda { |field, from, to|
    where("#{field} >= ? AND #{field} <= ?", from, to)
  })
  scope :after, (->(field, datetime) { where("#{field} > ?", datetime) })
  scope :before, (->(field, datetime) { where("#{field} < ?", datetime) })

  def self.belongs_to_models
    reflections.map do |_, ba|
      next unless ba.macro == :belongs_to
      {
        model_klass: ba.klass,
        relation_name: ba.name
      }
    end.compact
  end

  def self.boolean_as_time(attribute, field = "#{attribute}_at")
    define_method(attribute) do
      !send(field).nil? && send(field) <= -> { Time.current }.call
    end

    alias_method "#{attribute}?", attribute

    setter_attribute = "#{field}="
    define_method("#{attribute}=") do |value|
      if ActiveModel::Type::Boolean::FALSE_VALUES.include?(value)
        send(setter_attribute, nil)
      else
        send(setter_attribute, -> { Time.current }.call)
      end
    end
  end

  def human_model_name
    self.class.model_name.human
  end

  # ActiveAdmin display name
  def display_name
    "##{id || 'unsaved'} " + human_model_name
  end
end
