# frozen_string_literal: true

class ArbetsformedlingenAd < ApplicationRecord
  belongs_to :job
  has_many :arbetsformedlingen_ad_logs, dependent: :destroy

  validates :job, presence: true
  validates :occupation, inclusion: { in: Arbetsformedlingen::OccupationCode::CODE_MAP.keys } # rubocop:disable Metrics/LineLength

  validate :validate_job_data_for_arbetsformedlingen, if: :published

  scope :published, ->() { where(published: true) }
  scope :unpublished, ->() { where(published: false) }

  def validate_job_data_for_arbetsformedlingen
    return unless job

    wrapper = Arbetsformedlingen::JobWrapper.new(
      self,
      staffing_company: Company.default_staffing_company
    )
    return if wrapper.valid?

    wrapper.errors.each do |model_name, model_errors|
      model_errors.each do |arbetsformedlingen_model, field_errors_map|
        if field_errors_map.is_a?(Array)
          field_errors_map.each do |error|
            errors.add(
              map_arbetsformedlingen_model_name(model_name),
              "#{arbetsformedlingen_model.to_s.humanize.downcase} #{error}"
            )
          end
        else
          field_errors_map.each do |name, field_errors|
            field_errors.each do |error|
              errors.add(
                map_arbetsformedlingen_model_name(model_name),
                "#{name.to_s.humanize.downcase} #{error}"
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
#  occupation :string
#
# Indexes
#
#  index_arbetsformedlingen_ads_on_job_id  (job_id)
#
# Foreign Keys
#
#  fk_rails_...  (job_id => jobs.id)
#
