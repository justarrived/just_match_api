# frozen_string_literal: true

class ArbetsformedlingenAd < ApplicationRecord
  belongs_to :job
  has_many :arbetsformedlingen_ad_logs

  validates :job, presence: true

  validate :validate_job_data_for_arbetsformedlingen, if: :published

  def validate_job_data_for_arbetsformedlingen
    return unless job

    wrapper = Arbetsformedlingen::JobWrapper.new(job, published: published)
    return if wrapper.valid?

    wrapper.errors.each do |model_name, model_errors|
      model_errors.each do |arbetsformedlingen_model, field_errors_map|
        if field_errors_map.is_a?(Array)
          field_errors_map.each do |error|
            attr_name = map_arbetsformedlingen_attribute_name(arbetsformedlingen_model)
            errors.add(
              map_arbetsformedlingen_model_name(model_name),
              "#{attr_name.to_s.humanize.downcase} #{error}"
            )
          end
        else
          field_errors_map.each do |name, field_errors|
            field_errors.each do |error|
              attr_name = map_arbetsformedlingen_attribute_name(name)
              errors.add(
                map_arbetsformedlingen_model_name(model_name),
                "#{attr_name.to_s.humanize.downcase} #{error}"
              )
            end
          end
        end
      end
    end
  end

  def map_arbetsformedlingen_model_name(name)
    {
      company: 'company',
      packet: 'job',
      position: 'job',
      application_method: 'job',
      salary: 'job',
      schedule: 'job',
      document: 'job',
      publication: 'job'
    }.fetch(name, name)
  end

  def map_arbetsformedlingen_attribute_name(name)
    { ssyk_id: 'category ssyk' }.fetch(name, name)
  end
end

# == Schema Information
#
# Table name: arbetsformedlingen_ads
#
#  id         :integer          not null, primary key
#  job_id     :integer
#  published  :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_arbetsformedlingen_ads_on_job_id  (job_id)
#
# Foreign Keys
#
#  fk_rails_...  (job_id => jobs.id)
#
